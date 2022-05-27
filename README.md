# GCP Retail Solution

This repo contains utility code for the [Redis Enterprise Session Stability Store Solution Brief.](https://www.google.com) <br>
They are for demonstration purposes and not meant for production.  <br><br>


## Pre-requisites
Prior to running this retail application, please ensure following pre-requisites are installed and configured.

- [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- [yq - YAML/XML processor](https://pypi.org/project/yq/)


## High Level Workflow
The following is the high level workflow which you will follow:
1. Set up a Redis Enterprise Active-Active subscription on Google Cloud Platform
2. Build a docker image for the Cloud Run services hosting the retail application
3. Create a VPC network, VPC subnets and VPC connectors for private service access
4. Create a CloudSQL (MySQL) Master/Replica pair instances for storing the product catalog information
5. Populate product data into the MySQL database (named acme)
6. Deploy Cloud Run services running the retail application
7. Create a load balancer for the retail application serving in two GCP regions
8. Access the retail application via the load balancer's endpoint
9. Tear down the environment




