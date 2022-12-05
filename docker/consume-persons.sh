#!/bin/bash
#olusturucagimiz topici dinlemek icin
bin/kafka-console-consumer.sh --bootstrap-server 0.0.0.0:9092 --from-beginning --topic debezium.public.persons | jq '.'
