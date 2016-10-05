# postgisd
PostgreSQL with PostGis Docker


### Running


	docker run --name postgis1 -v /opt/var/lib/postgis1:/var/lib/postgresql/data \
		-h postgis1 -e DATABASE_USER=user1 -e DATABASE_NAME=db1 \
		-e DATABASE__PASSWORD=password1 suquant/postgisd:9.6.0



### Using


	psql -h `docker inspect -f "{{ .NetworkSettings.IPAddress }} postgis1"` -U user1 -W db1
