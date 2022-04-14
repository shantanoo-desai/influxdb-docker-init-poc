#!/bin/bash
# Copyright 2022 Shantanoo "Shan" Desai <shantanoo.desai@gmail.com>

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# Bootstrapping Script for InfluxDBv2.1 executed by the Docker Init Container

set -e

# Set Default Values if not provided by Env Vars
DEFAULT_INFLUXDB_BUCKET=initBucket
DEFAULT_INFLUXDB_ORG=initOrg
DEFAULT_INFLUXDB_USERNAME=initAdmin
DEFAULT_INFLUXDB_PASSWORD=securePassword
DEFAULT_INFLUXDB_ADMIN_TOKEN=initToken

# Set the environment variables from the init container
# If not provided use default values
DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN:-$DEFAULT_INFLUXDB_ADMIN_TOKEN}
DOCKER_INFLUXDB_INIT_BUCKET=${DOCKER_INFLUXDB_INIT_BUCKET:-$DEFAULT_INFLUXDB_BUCKET}
DOCKER_INFLUXDB_INIT_ORG=${DOCKER_INFLUXDB_INIT_ORG:-$DEFAULT_INFLUXDB_ORG}
DOCKER_INFLUXDB_INIT_PASSWORD=${DOCKER_INFLUXDB_INIT_PASSWORD:-$DEFAULT_INFLUXDB_PASSWORD}
DOCKER_INFLUXDB_INIT_USERNAME=${DOCKER_INFLUXDB_INIT_USERNAME:-$DEFAULT_INFLUXDB_USERNAME}

## Custom Setup
CUSTOM_BUCKET=coreData
CUSTOM_ORG=coreOrg
CUSTOM_USER=edgeCoreUser
CUSTOM_PASSWORD=edgeCoreUsersPassword

# Setup InfluxDB using the `setup` command
influx setup --bucket ${DOCKER_INFLUXDB_INIT_BUCKET} -t ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN} -o ${DOCKER_INFLUXDB_INIT_ORG}  --username="${DOCKER_INFLUXDB_INIT_USERNAME}" --password="${DOCKER_INFLUXDB_INIT_PASSWORD}" --host=http://influxdb:8086 -f


# Create a Custom Organization
influx org create -n ${CUSTOM_ORG} --host=http://influxdb:8086 -t ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}

# Create a Custom Bucket, in the Org with retention policy of 24 hours
influx bucket create -n ${CUSTOM_BUCKET} -o ${CUSTOM_ORG} -r 24h --host=http://influxdb:8086 -t ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}

# Create a Custom User 
influx user create -n ${CUSTOM_USER} -p ${CUSTOM_PASSWORD} -o ${CUSTOM_ORG} --host=http://influxdb:8086 -t ${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}
