# irods_demo

## Requirements

- docker
- docker-compose

A minimal configuration will have:

- 2 CPUs
- 4 GB RAM
- 10 GB storage

## Run

If you have not initialized submodules in this repo, run the following before attempting to start the Compose project:
```
$ git submodule update --init
```
`git submodule update` should be run any time the submodule is updated, so make sure to run it any time you pull or checkout different commits.

To run all services:
```bash
$ docker-compose up
```

To run an individual service (and all services on which it depends):
```bash
$ docker-compose up <service-name>
```

For example, this command will spawn containers for the following services:

1. `irods-catalog`
2. `irods-catalog-provider`
3. `irods-client-rest-cpp`
4. `nginx-reverse-proxy`
5. `irods-client-zmt`

```bash
$ docker-compose up irods_client_zmt
```

For more information about Compose CLI options, see Docker Compose documentation: https://docs.docker.com/engine/reference/commandline/compose
