# Initialize and Provision your InfluxDBv2.x Container using Docker Init Containers

Proof-of-Concept of Provisioning your InfluxDBv2.x container through Docker Init Containers using Compose files

InfluxDB has already of provisioning the database by using scripts as volume mounts in the `/docker-entrypoint-initdb.d`
directory. See [Docker Hub Documentation for InfluxDB under section Custom Initialization Scripts][1].

This Repository is a proof-of-concept that once achieve similar initialization via the docker init containers in compose file

## Usage

```bash
docker compose up
```

Should provide you verbose logs that the default initialization user and a custom user are created via the `init-db`
docker init containers.

## Results

- Login into the UI at `http://localhost:8086` using the default admin credentials (see `influxdb.env`)

- Once logged into UI click User Icon on the left-side panel you will observe the provisioned Organization in the `bootstrap-influxdb.sh`
script

![Provisioned Organizations in InfluxDB UI main page](./.github/assets/influxdb_ui_home_orgs.png)

- Select the `coreOrg` organization and click on the user icon on left-side panel and click on __Members__, you also see the provisioned
members

![Provisioned User in InfluxDB Org coreOrg](./.github/assets/influxdb_ui_user.png)

## Docker Init Container in Compose

> NOTE: this feature is similar to [Kubernetes Init Containers][1], which is available for
> Docker Compose since version 1.29.

The Init Container can initialize your container by using the `depends_on` spec. Depending on the
intialization process, you can set three conditions of the container's state you wish to initialize:

- `service_started`
- `service_healthy`
- `service_completed_sucessfully`

Unfortunately, this feature is yet to be documented. However, some resources to look into:

1. [Feature Request Issue on Docker Compose ][2]
2. [Pending Pull-Request for Documentation of Init Containers][3]
3. [StackExchange Query with a _possible_ example][4]

[1]: https://hub.docker.com/_/influxdb/
[2]: https://github.com/docker/compose/issues/6855
[3]: https://github.com/docker/docker.github.io/issues/12633
[4]: https://stackoverflow.com/questions/70322031/does-docker-compose-support-init-container