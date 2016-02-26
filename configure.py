#!/usr/bin/env python
# -*- coding: utf-8 -*-

from os import path, getcwd, getenv
from collections import defaultdict
config = defaultdict(defaultdict)

config["importer"] = "osm2pgsql" # either 'imposm' or 'osm2pgsql'

# The name given to the style. This is the name it will have in the TileMill
# project list, and a sanitized version will be used as the directory name
# in which the project is stored
config["name"] = "OSM Bright"

# The absolute path to your MapBox projects directory. You should
# not need to change this unless you have configured TileMill specially
config["path"] = "/opt/osm-bright-master"

# PostGIS connection setup
# Leave empty for Mapnik defaults. The only required parameter is dbname.
config["postgis"]["host"]     = getenv("OSM_DB_HOST", "osm_db")
config["postgis"]["port"]     = getenv("OSM_DB_PORT", "")
config["postgis"]["dbname"]   = getenv("OSM_DB_NAME", "srs_osm_db")
config["postgis"]["user"]     = getenv("OSM_DB_USER", "srs_rw_user")
config["postgis"]["password"] = getenv("OSM_DB_PASS", "password")

# Increase performance if you are only rendering a particular area by
# specifying a bounding box to restrict queries. Format is "XMIN,YMIN,XMAX,YMAX"
# in the same units as the database (probably spherical mercator meters). The
# whole world is "-20037508.34 -20037508.34 20037508.34 20037508.34".
# Leave blank to let Mapnik estimate.
config["postgis"]["extent"] = "-20037508.34,-20037508.34,20037508.34,20037508.34"

# Land shapefiles required for the style. If you have already downloaded
# these or wish to use different versions, specify their paths here.
# You will need to unzip these files before running make.py
# These OSM land shapefiles are updated daily and can be downloaded at:
# - http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
# - http://data.openstreetmapdata.com/land-polygons-split-3857.zip

config["land-high"] = "/usr/share/mapnik-osm-carto-data/land-polygons-split-3857/land_polygons.shp"
config["land-low"] = "/usr/share/mapnik-osm-carto-data/simplified-land-polygons-complete-3857/simplified_land_polygons.shp"
