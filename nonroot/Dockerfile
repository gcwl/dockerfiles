ARG FROM
FROM $FROM as nonroot

# install sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
# create user/group and grant sudo privilege
ARG NONROOT=nonroot
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $NONROOT \
  && useradd -u $UID -g $GID -d /workspace -s /bin/bash $NONROOT \
    && echo "${NONROOT} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/1337-${NONROOT} \
    && chown -R $NONROOT:$NONROOT /workspace
# default user as $NONROOT
USER $NONROOT
