# osm-catalunya-transport-public
Tools to import and mantain public transport data from opendata in differents
formats to OpenStreetMap

## Main data sources
1. [AMB](http://www.amb.cat) (Autoritat Metropolitana de Barcelona) provides a
[GTFS dataset](http://www.amb.cat/ca/web/area-metropolitana/dades-obertes/cataleg/detall/-/dataset/informacio-de-companyies--linies-i-recorreguts/1033377/11692)
with the bus lines off the city of Barcelona
2. [TMB](http://www.tmb.cat) (Transports Metropolitans de Barcelona) provides
a [GTFS dataset](https://www.tmb.cat/en/about-tmb/tools-for-developers) with
the bus and metro lines of the city of Barcelona
3. [FGC](http://www.fgc.cat) (Ferrocarrils de la Generalitat de Catalunya)
provides a [GTFS dataset](http://dadesobertes.gencat.cat/ca/cercador/detall-cataleg/?id=178)
with suburban train lines and metro lines that depend on the Catalonia
Government
4. [Generalitat de Catalunya](http://www.gencat.cat) provide a [propietary
format dataset](http://dadesobertes.gencat.cat/ca/cercador/detall-cataleg/?id=7372)
with interurban bus lines of Catalonia

## Other datasources
Less structured data that can be found in other opendata portals

1. [Terrassa](http://www.terrassa.cat) city council provide a [shapefile](https://opendata.terrassa.cat/MOBILITAT_I_TRANSPORT/Transports-P-blics-de-Terrassa-Transportes-P-blico/7tbd-7azw)
and a [data table](https://opendata.terrassa.cat/MOBILITAT_I_TRANSPORT/Parades-i-horaris-bus-Paradas-y-horarios-bus-Bus-s/b6md-6f8c)
with the city bus lines and schedule
2. [Sabadell](http://www.sabadell.cat) city council provide a [set of files](http://opendata.sabadell.cat/ca/inici/fitxes-cataleg?option=com_iasmetadadesarticles&cod=OD,CT-3-&title=Transports)
provide a set of KML files with the bus lines of the city.

## Data process

### Tools used
The GTFS files are processed with the [gtfsdb](https://github.com/OpenTransitTools/gtfsdb)
to import to a database (postgreSQL + PostGIS).
An example of the import command:
```sh
$ ./bin/gtfsdb-load --database_url postgresql://your-username:your-password@localhost:5432/amb --is_geospatial ../google_transit-amb.zip
```
It is recommended to create a different cluster with the different databases
because the different gtfs files must be stores in different databases
An example of the commands to set up a cluster and a PostGIS database:
```sh
$ sudo pg_createcluster -d /home/db/postgresql/clusters/gtfs -l /home/db/postgresql/logs/gtfs.log -p 5435 --start --start-conf auto 9.5 gtfs
$ sudo su postgres
$ createuser -p 5435 -P gtfsuser
$ createdb -p 5435 -E UTF8 -O gtfsuser amb
$ psql -p 5435 -d amb -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology; CREATE EXTENSION postgis_sfcgal;"
$ exit
```

### Dirty Data Hacks
Unfortunately not all GTFS files are 100% standard compliant. For example,
the TMB dataset do not provide a valid `agency_id` in the `routes.txt` file.

#### TMB Files
* Add `agnecy_id` to the routes
```SQL
UPDATE routes SET agency_id = 1;
```
