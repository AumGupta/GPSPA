# REST API Working example

This code serves as a simple (and rough) example on how to create a REST API using Flask.
It has examples on how to connect to a PostgreSQL database and create GET, POST, PUT and DELETE endpoints that allows user to Create, Read, Update and DELETE (CRUD) in the database.

## What is flask?

Flask is a web framework, it’s a Python module that lets you develop web applications easily.

## Pre-requisites

This example uses the `taxidb` database created and populated using the ETL pipeline from last session (08 - ETL working example).

## How to run it?

1. Create a new conda environment and make sure to install the packages in requirements.txt in it. You can do it in one step with the following command running inside the 09 - API working example:

   conda create -n api_example --file requirements.txt

2. Using PgAdmin (or any other PostgreSQL client), run the `00_create_rides_geojson_view.sql` file on `taxidb` database query tool to create a new view with curated data.

3. Start the application running:

   ```
   python main.py
   ```
4. The application will start and will be available on `localhost:5000`

# How to test it?

## notebook
Use the [testing_the_taxis_api.ipynb] notebook to see how another aplication would interact with the taxis API we created.

## Browser
You can run direct URLs in your browser pointing to get information from the API:
http://localhost:5000/rides
http://localhost:5000/rides/3


# Alternatively, you can use Postman to test your API

1. Install Postman from `https://www.postman.com/downloads/`
2. Open postman and try to do some requests
3. Try a GET with `localhost:5000/rides/3`
4. Try a GET with `localhost:5000/rides/50`
5. Try a DELETE with `localhost:5000/rides/50`
6. Check what happened in the taxidb database
7. Try a GET with `localhost:5000/rides/50` again
8. Try a POST with `localhost:5000/rides` using the body in post_examples.json content
9. Check if there's a new record in the taxidb database
10. Try a PUT with `localhost:5000/rides/3` using the body in put_examples.json content
11. Try a GET with `localhost:5000/rides/3` again

#
