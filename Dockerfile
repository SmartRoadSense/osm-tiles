FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
COPY multiverse.list /etc/apt/sources.list.d/
RUN apt update && \
    apt install -y \
      apache2 \
      libmapnik2.2 \
      lua5.1 \
      mapnik-utils \
      munin \
      munin-node \
      node-carto \
      software-properties-common \
      supervisor \
      ttf-unifont && \
    add-apt-repository ppa:kakrueger/openstreetmap && \
    apt update && \
    apt install -y \
      libapache2-mod-tile && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/mapnik-osm-carto-data/*.zip && \
    rm -rf /usr/share/mapnik-osm-carto-data/*.tgz && \
    python -c 'import mapnik'

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_SERVERADMIN=admin@localhost \
    APACHE_SERVERNAME=localhost
EXPOSE 8000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

ADD osm-bright-master.tar.xz /opt/
ADD ne_10m_populated_places_simple.tar.xz /usr/share/mapnik-osm-carto-data/
COPY renderd.conf /etc/
COPY configure.py /opt/osm-bright-master/
COPY osm-bright.osm2pgsql.mml /opt/osm-bright-master/osm-bright/
COPY apache_site.conf /etc/apache2/sites-available/tileserver_site.conf
COPY apache2.conf /etc/apache2/apache2.conf
COPY apache_ports.conf /etc/apache2/ports.conf
COPY mod_tile.conf /etc/apache2/conf-available/
COPY supervisord.conf /etc/supervisor/
RUN cd /usr/share/mapnik-osm-carto-data/land-polygons-split-3857/ && \
      shapeindex land_polygons.shp && \
    cd /usr/share/mapnik-osm-carto-data/simplified-land-polygons-complete-3857/ && \
      shapeindex simplified_land_polygons.shp && \
    cd /opt/osm-bright-master/ && \
      ./make.py && \
    cd /opt/osm-bright-master/OSMBright/ && \
      carto project.mml > OSMBright.xml && \
    a2enconf mod_tile

RUN mkdir -p /run /var/log/apache2 && \
  chown www-data: -R /run /var/log/apache2
USER www-data
WORKDIR /tmp
