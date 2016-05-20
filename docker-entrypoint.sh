#!/bin/bash

# replace the password if OSM_DB_PASS is set
if [ -z ${OSM_DB_PASS} ]; then
  echo 'WARNING: OSM_DB_PASS is not set'
else
  echo 'Replacing the password with OSM_DB_PASS value'
  sed -i "s/CDATA\[password\]/CDATA\[${OSM_DB_PASS}\]/g" /opt/osm-bright-master/OSMBright/OSMBright.xml
fi

# run the provided command
echo "Running $@"
exec "$@"
