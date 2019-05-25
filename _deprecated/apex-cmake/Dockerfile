ARG WHOAMI
FROM ${WHOAMI}/apex

# build cmake (required by building many other tools)
WORKDIR /tmp
RUN git clone https://github.com/Kitware/CMake.git
WORKDIR /tmp/CMake
RUN ./bootstrap && make && make install

# clean up
RUN rm -rf /tmp/*

# set default directory
WORKDIR /workspace
