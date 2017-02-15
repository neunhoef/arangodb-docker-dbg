# Usage

## Generate the build image

Use this Dockerfile:

https://github.com/arangodb-helper/build-docker-containers/blob/master/distros/debian/jessie/build/Dockerfile

```
HOST$ git clone https://github.com/arangodb-helper/build-docker-containers
HOST$ docker build -t arangodb/debian-jessie-builder build-docker-containers/distros/debian/jessie/build/
```

## Create a local build container

First `cd` to the directory containing arangodb

Then create the build container:

The `--name` is totally optional but might help you to locate the container later afterwards.
Choose whatever name you like.

```
HOST$ docker create -it -v $(pwd):/arangodb --name debian-jessie-builder-devel arangodb/debian-jessie-builder bash
```

## Create the required debs

```
HOST$ docker start debian-jessie-builder-devel
HOST$ docker exec -it debian-jessie-builder-devel bash
CONTAINER$ cd /arangodb && ./scripts/build-deb.sh
CONTAINER$ mv /var/tmp/*.deb build-deb/
```

## Create the release and debug container

Files, versions etc. are dynamic so please adjust

```
HOST$ git clone https://github.com/arangodb/arangodb-docker # first time only
HOST$ git clone https://github.com/arangodb-helper/arangodb-docker-dbg # first time only
HOST$ cd arangodb-docker
HOST$ cp $ARANGO_SOURCE_TREE/build-deb/$RELEASE_DEB.deb arangodb.deb
HOST$ docker build -t $USER/arangodb:$VERSION -f Dockerfile3.local .
HOST$ cd ..
HOST$ cd arangodb-docker-dbg
HOST$ docker tag $USER/arangodb:$VERSION arangodb/arangodb
HOST$ cp $ARANGO_SOURCE_TREE/build-deb/$DEBUG_DEB.deb arangodb-dbg.deb
HOST$ docker build -t $USER/arangodb-dbg:$VERSION .
```

## Run the container

```
HOST$ docker run --privileged -e ARANGO_NO_AUTH=1 --name myarangodb $USER/arangodb-dbg:$VERSION
```

## Attach with the debugger

```
HOST$ docker exec -it myarangodb gdb -p 1
```
