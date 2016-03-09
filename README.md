# postgisd
PostgreSQL with PostGis Docker


### Running

```
docker run --name postgis1 -v /opt/var/lib/postgis1:/var/lib/postgresql/data \
	-h postgis1 -e POSTGRES_USER=user1 -e POSTGRES_DB=db1 \
	-e POSTGRES_PASSWORD=password1 suquant/postgisd:v1.0.1
```


### Using

```
psql -h `docker inspect -f "{{ .NetworkSettings.IPAddress }} postgis1"` -U user1 -W db1
```
