# Debezium Connect Demo

If you want to install Debezium on your local, check the debezium-connect-with-docker directory.

If you want to create the kubernetes pipeline of Debezium, check the debezium-connect-with-k8s directory.


# Debezium Demo

With this demo you can create Zookeeper, Kafka, PostgreSQL and Debezium (Kafka Connect) instance on your Docker. Then with the spring boot application you can create a table in your postgresql container and you can do CRUD operations.


## Requirements

- Docker
- Java 11

## Usage

First, go to the docker directory and create all the containers needed with the ```docker-compose up``` command. Some script files will be added to the cantainers that will be created. With these scripts, it is possible to list Kafka topics and consume to the topic named "debezium.public.persons". 

Once all containers have been successfully created, build the application. While the application is being built, a table named persons will be created on PostgreSQL with liquibase.

After these steps, a connector must be created for the persons table. The following command will be used to create the connector.

```bash
curl --location --request POST '127.0.0.1:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{ 
"name": "debezium-test-connector", 
"config": { 
	"connector.class": "io.debezium.connector.postgresql.PostgresConnector",
	"database.hostname": "{local-ip}", 
	"database.port": "5432", 
	"database.user": "user", 
	"database.password": "password", 
	"database.dbname" : "debezium",
	"database.server.name": "debezium", 
	"database.whitelist": "public", 
	"table.whitelist": "public.persons",
	"heartbeat.interval.ms": "5000",
	"slot.name": "debezium",
	"key.converter": "org.apache.kafka.connect.json.JsonConverter",
	"key.converter.schemas.enable": "false",
	"value.converter": "org.apache.kafka.connect.json.JsonConverter",
	"value.converter.schemas.enable": "false",
	"plugin.name":"pgoutput"
	} 
}'
```

Finally, with the ```docker exec -u 0 -it kafka /bin/bash``` command, you can enter the Kafka container and list its topics and consume the created topic.

For list all topics and consume created topic, scripts that we create before can be used. 

- Install JQ (Json beautifier for terminal): ```./install-jq.sh``` 
- List all topics: ```./list-topic.sh```
- Consume created topic: ```./consume-persons.sh```


debezium-docker installation

1. docker compose up -d or docker-compose up -d
2. docker exec -it postgresql /bin/bash
3. psql -ddebezium -Uuser
4. show wal_level; check wal_level must be logical
3. docker exec -it -uroot kafka /bin/bash  then ./install-jq.sh
4. check topics in kafka. ./list-topic.sh we declared them in env
5. docker exec -it debezium /bin/bash then check the connect folder. cd connect; ls (bu dosyalar db-kafkaconnect-kafka icin gerekli)
bu dosyaların yolunu connect-distributed.properties configinde image ile birlikte hazır olarak veriyor.On-prem sunucu da bu configi elle düzenlemek gerekicek. cat config/connect-distributed.properties
6. Springboot uyg ayağı kaldırılır.
7. postman üzerinde http://localhost:8080/persons get post işlemleri yapılır.
8. 127.0.0.1:8083/connectors/ e config basılır. local-ip kısmına 127.0.0.1 çalışmazsa wlo1 ya da eth0,1 vs girilebilir.(pg connection error)
{ 
"name": "debezium-test-connector", 
"config": { 
	"connector.class": "io.debezium.connector.postgresql.PostgresConnector",
	"database.hostname": "{local-ip}", 
	"database.port": "5432", 
	"database.user": "user", 
	"database.password": "password", 
	"database.dbname" : "debezium",
	"database.server.name": "debezium", 
	"database.whitelist": "public", 
	"table.whitelist": "public.persons",
	"heartbeat.interval.ms": "5000",
	"slot.name": "debezium",
	"key.converter": "org.apache.kafka.connect.json.JsonConverter",
	"key.converter.schemas.enable": "false",
	"value.converter": "org.apache.kafka.connect.json.JsonConverter",
	"value.converter.schemas.enable": "false",
	"plugin.name":"pgoutput"
	} 
}
9. docker exec -it -uroot kafka /bin/bash
kafkaya girilir ve topicler görüntülenir. ./list-topic.sh 
__consumer_offsets
__debezium-heartbeat.debezium
debezium.public.persons --> db ye kayıt yapıldığında ortaya çıkar.
debezium_connect_config
debezium_connect_offset
debezium_connect_status
10. ./consume-persons.sh ile topic consume edilebilir. (öncesinde install-jq sh'ını çalıştır.)
11. put,update işlemi yapıldığında http://localhost:8080/persons/1 beforun null geldiği görülür.
bunu düzeltmek için replica_identityi FULL e çekmek gerekmekte.
debezium=# ALTER TABLE REPLICA IDENTITY FULL; sonrasında before identitysi gelecektir.
consumer üzerinden görüntülenebilir.







