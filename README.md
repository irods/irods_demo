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

## Notes for services

### `irods-client-zmt` / Zone Management Tool / ZMT

The ZMT service assumes that containers are running on the same host as the browser. If this is not the case, the value of `REACT_APP_REST_API_URL` should be changed to an address which correctly maps to the `nginx-reverse-proxy` service and that is reachable by both the ZMT service and the host running the browser.

### `irods-client-nfsrods` / NFSRODS

Once the service is running, the NFS server needs to be accessed from a mountpoint. This can be done with the following command:
```bash
$ sudo mount -o sec=sys,port=2050 localhost:/ ./irods_client_nfsrods/nfs_mount
```
The hostname can also be the IP address of the container providing the service in the `irods_demo_default` Docker network if running from the same host. The mountpoint can exist on any other machine which can reach the host running the container providing the service because the port is being exposed, in which case the FQDN or IP address for the host machine can be used. For more information about mounting NFSRODS, see the README for the project: https://github.com/irods/irods_client_nfsrods#mounting

When you are ready to stop the service, it would be a good idea to unmount first. This can be done by running the following:
```bash
$ sudo umount ./irods_client_nfsrods/nfs_mount
```

The NFSRODS service maps the `/etc/passwd` file on the host machine to the `/etc/passwd` file in the container providing the service. The user(s) accessing the mountpoint will need to exist as iRODS users as well in order to be able to interact with the mountpoint. This can be done by running the following command on the host machine for each `username` which needs to be mapped:
```bash
$ docker exec irods_demo_irods-client-icommands_1 iadmin mkuser <username> rodsuser
```
