# demo
Ejemplo del uso de contenedores para el desarrollo de aplicaciones

## ¿Cómo ejecutarlo?

1. Para crear la base de datos, ejecutar el siguiente comando desde el directorio raíz (donde se encuentra el archivo schema.sql)

```bash
docker network create demo-net || true

docker run -d \
    --name mariadb \
    --network demo-net \
    -e MARIADB_ROOT_PASSWORD=rootpw \
    -e MARIADB_DATABASE=demodb \
    -e MARIADB_USER=demo \
    -e MARIADB_PASSWORD=demopw \
    -v $(pwd)/schema.sql:/docker-entrypoint-initdb.d/schema.sql:ro \
    -p 3306:3306 \
    mariadb:11
```

2. Crear la imagen de la aplicación y ligarla con la base de datos

```bash
docker build -t demoapp:v1.0.0 .

docker run -d \
    --name flask-app \
    --network demo-net \
    -e DB_HOST=mariadb \
    -e DB_USER=demo \
    -e DB_PASSWORD=demopw \
    -e DB_NAME=demodb \
    -p 8000:8000 \
    flask-mariadb-demo
```

3) Abrir la aplicación en el navegador con http://localhost:8000

