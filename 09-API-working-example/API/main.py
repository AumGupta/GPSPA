from flask import (
    Flask, 
    request,
    jsonify,
    sql,
    )
import psycopg2
from psycopg2.extras import RealDictCursor
from utils import format_geojson

DB_CONFIG = {
    "database": "taxidb",
    "user": "aneto",
    "password": "castor107",
    "host": "localhost",
    "port": "5432"}

# Notice, normally this is set with environment variables on the server
# machine do avoid exposing the credentials. Something like
# import os
# DB_CONFIG = {}
# DB_CONFIG['database'] = os.environ.get('DATABASE')
# DB_CONFIG['username'] = os.environ.get('USERNAME')
# ...

# Create a flask application
app = Flask(__name__)

# Database connection function
def get_db_connection():
    return psycopg2.connect(
        database=DB_CONFIG["database"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"],
        cursor_factory=RealDictCursor
    )

# GET all rides from pa.rides_geojson
@app.route('/rides3', methods=['GET'])
def get_rides():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""SELECT * FROM pa.rides LIMIT 50""")
    rides = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rides)

# GET all rides from pa.rides_geojson getting a GeoJSON column
@app.route('/rides2', methods=['GET'])
def get_rides2():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""SELECT id,
	                    pickup_datetime, 
	                    dropoff_datetime,
	                    passenger_count,
	                    st_asGeoJSON(st_makeline(pickup, dropoff))::json as geom
                      FROM pa.rides Limit 50;""")
    rides = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rides)

# GET all rides from pa.rides_geojson using a prepared view (00_create_rides_geojson_view)formatted as a proper GeoJSON
@app.route('/rides', methods=['GET'])
def get_rides3():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""SELECT * FROM pa.rides_geojson LIMIT 10""")
    rides = cursor.fetchall()
    cursor.close()
    conn.close()
    # Format the all result as a GeoJSON
    rides = format_geojson(rides)
    return jsonify(rides)

# GET a single ride by id from pa.rides_geojson
@app.route('/rides/<id>', methods=['GET'])
def get_ride(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM pa.rides_geojson WHERE id = %s", (id,))
    ride = cursor.fetchall()
    ride = format_geojson(ride)
    cursor.close()
    conn.close()

    if not ride:
        return jsonify({"message": "Ride not found"}), 404

    return jsonify(ride)

# POST a new ride to sa.rides
@app.route('/rides', methods=['POST'])
def create_ride():
    body = request.get_json()
    conn = get_db_connection()
    cursor = conn.cursor()

    query = """
        INSERT INTO sa.rides (
            pickup_datetime, dropoff_datetime, pickup_latitude, pickup_longitude,
            dropoff_latitude, dropoff_longitude, passenger_count, rate_code,
            payment_type, tip_amount, total_amount
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id
    """
    values = (
        body["pickup_datetime"], body["dropoff_datetime"], body["pickup_latitude"], 
        body["pickup_longitude"], body["dropoff_latitude"], body["dropoff_longitude"], 
        body["passenger_count"], body["rate_code"], body["payment_type"], 
        body["tip_amount"], body["total_amount"]
    )

    cursor.execute(query, values)
    # This gets the id of the created ride because of the "RETURNING id" in the insert query
    created_id = cursor.fetchone()["id"]
    
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": f"New {created_id} ride created"}), 201

# PUT method to update a ride in pa.rides by id
@app.route('/rides/<id>', methods=['PUT'])
def update_ride(id):
    body = request.get_json()
    conn = get_db_connection()
    cursor = conn.cursor()

    # Build the update query dynamically
    for key, value in body.items():
        key = key.replace(';','') # This will sanitize the key to make sure there's no code injection in the query
        query = "UPDATE pa.rides SET " + key + " = %s WHERE id = %s"
        cursor.execute(query, (value, id,))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({"message": f"Ride {id} updated successfully"})

# DELETE a ride by id from sa.rides
@app.route('/rides/<id>', methods=['DELETE'])
def delete_ride(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM sa.rides WHERE id = %s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": f"Ride {id} was deleted successfully"})

# EXERCISE
# CREATE A GET route to get monthly statistics
# Tips: Check ETL Query results for a query that gives you that

if __name__ == '__main__':
    app.run(debug=True)
