ARG FROM
FROM $FROM as nonroot

# install sudo
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# create user/group and grant sudo privilege
ARG NONROOT=nonroot
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $NONROOT \
  && useradd -u $UID -g $GID -d /workspace -s /bin/bash $NONROOT \
  && echo "${NONROOT} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/1337-${NONROOT}

# /workspace as $HOME for $NONROOT
ADD ./tmux.conf /workspace/.tmux.conf
RUN cp /root/.bashrc /workspace/ && cp /root/.profile /workspace/ \
  && mkdir -p -m 700 /workspace/.jupyter/ && echo "c.NotebookApp.ip = '*'" >> /workspace/.jupyter/jupyter_notebook_config.py \
  && chown -R $NONROOT:$NONROOT /workspace

WORKDIR /workspace
VOLUME [ "/workspace" ]

# login as $NONROOT
USER $NONROOT

CMD [ "/usr/bin/tmux" ]
