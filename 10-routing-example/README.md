# Network Analysis with PgRouting and Openstreemaps

This example is aimed to show you how to download data from OpenStreetMaps, import it to a PostgreSQL/PostGIS database and perform some usual network analysis operations.

## Requirements

* PostgreSQL
* PostGIS
* PgRouting
* osm2pgrouting
* osmium tool (https://osmcode.org/osmium-tool/)

Alternative

* osmconvert (https://wiki.openstreetmap.org/wiki/Osmconvert)

## Instructions

1. Using PgAdmin, create a new database called lisboa_routing
2. Install the PostGIS and PgRouting extensions
3. Go to geofabrik and download the portugal-latest.pbf file (https://download.geofabrik.de/europe/portugal.html)
4. Convert the .pbf file into .osm and clip the data to your needs, in this case using lisbon extent

   * Option 1 - Using osmium:

         osmium extract portugal-latest.osm.pbf -b -9.23,38.68,-9.08,38.79 -o lisboa.osm

   * Option 2 - Using osmconvert:

         osmconvert64-0.8.8p.exe portugal-latest.osm.pbf -b=-9.23,38.68,-9.08,38.79 --complete-ways -o=lisboa.osm

     Note: Instead of the boundingbox coordinates you can use a shapefile in wgs84 to clip the input data


5. Use osm2pgrouting command line tool to import the `lisboa.osm` file into your prepared database. Type `osm2pgrouting --help` to see all the commands. Then, for our particular use, we need to run:

    osm2pgrouting -f lisboa.osm --dbname lisboa_routing --username postgres --host localhost --port 5432 -W postgres -c config_files\mapconfig_for_cars.xml

    The mapconfig_for_cars.xml contains the necessary configurations to create a cars network. This file is originally saved in the PostgreSQL installation folder (C:\Program Files\PostgreSQL\16\bin) and you will find other configuration files prepared for other routing problems. You can edit those files.

6. Your network should be ready on your database, let's have a look at it. Open PgAdmin and for the lisboa_routing database open the
7. The osm2pgrouting tool create two main tables. One with all the streets (ways), and another with the network nodes (ways_vertices_pgr)
8. The ways table have lot's of columns, the most important ones, that will be used in routing are:

   * gid - the identifier of the street
   * source - the id of the node at the street start point
   * target - the id of the node at the street ending point

   The are also some columns with the cost, reverse_cost, oneway, length_m, these were created based on the configuration file that was used.

