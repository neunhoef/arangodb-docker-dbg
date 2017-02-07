FROM arangodb/arangodb

RUN echo "add-auto-load-safe-path /" > /root/.gdbinit && \
    echo "set substitute-path /arangodb/ /src/arangodb/" >> /root/.gdbinit

COPY arangodb-dbg.deb /arangodb-dbg.deb
RUN dpkg -i /arangodb-dbg.deb
RUN apt-get update && apt-get install -y gdb wget unzip elfutils
RUN mkdir /src && \
    cd /src && \
    VERSION=$(arangod --version | grep '^build-repository' | sed 's/.*-g\([0-9a-f]\+\).*/\1/g') && \
    echo "HAHA $VERSION" && \
    wget -c https://github.com/arangodb/arangodb/archive/${VERSION}.zip && \
    unzip -q ${VERSION}.zip && \
    mv arangodb-* arangodb
