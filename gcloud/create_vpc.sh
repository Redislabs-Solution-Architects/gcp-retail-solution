#!/bin/bash

vpc_network=$1
vpc_subnet_east=$2
vpc_connector_east=$3
vpc_subnet_west=$4
vpc_connector_west=$5
project_id=$6


gcloud compute networks create $vpc_network \
	--subnet-mode=custom

gcloud compute networks subnets create $vpc_subnet_east \
	--network=$vpc_network \
	--range=10.50.0.0/24 \
	--region=us-east1

gcloud compute networks subnets create $vpc_subnet_west \
        --network=$vpc_network \
        --range=10.60.0.0/24 \
        --region=us-west1

gcloud compute networks vpc-access connectors create $vpc_connector_east \
	--region us-east1 \
	--network $vpc_network \
	--range 10.52.0.0/28

gcloud compute networks vpc-access connectors create $vpc_connector_west \
        --region us-west1 \
        --network $vpc_network \
        --range 10.62.0.0/28

# Configure private service access for private CloudSQL MySQL connection
gcloud compute addresses create google-managed-services-$vpc_network \
	--global \
	--purpose=VPC_PEERING \
	--prefix-length=16 \
	--network=projects/$project_id/global/networks/$vpc_network

gcloud services vpc-peerings connect \
	--service=servicenetworking.googleapis.com \
	--ranges=google-managed-services-$vpc_network \
	--network=$vpc_network \
	--project=$project_id


