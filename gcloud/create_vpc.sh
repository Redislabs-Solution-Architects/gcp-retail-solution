#!/bin/bash

vpc_network=$1
vpc_subnet_east=$2
vpc_connector_east=$3
vpc_subnet_west=$4
vpc_connector_west=$5


gcloud compute networks create $vpc_network \
	--subnet-mode=custom

gcloud compute networks subnets create $vpc_subnet_east \
	--network=$vpc_network \
	--range=10.70.0.0/24 \
	--region=us-east1

gcloud compute networks subnets create $vpc_subnet_west \
        --network=$vpc_network \
        --range=10.80.0.0/24 \
        --region=us-west1

gcloud compute networks vpc-access connectors create $vpc_connector_east \
	--region us-east1 \
	--network $vpc_network \
	--range 10.72.0.0/28

gcloud compute networks vpc-access connectors create $vpc_connector_west \
        --region us-west1 \
        --network $vpc_network \
        --range 10.82.0.0/28


