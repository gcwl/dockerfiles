ARG PREFIX
FROM ${PREFIX}/apex

# install from conda:main
RUN /opt/conda/bin/conda install -y \
  tqdm \
  pyyaml \
  ujson \
  tabulate \
  sqlalchemy \
  jupyter \
  h5py \
  pyarrow \
  pandas \
  snappy \
  blosc \
  statsmodels \
  scikit-learn \
  matplotlib \
  seaborn \
  bokeh \
  graphviz \
  pydot \
  networkx \
  scikit-image \
  imageio \
  ftfy \
  nltk \
  spacy \
  "dask[complete]" \
  joblib \
  lxml \
  requests \
  beautifulsoup4 \
  scrapy \
  tensorflow-gpu \
  tensorboard \
  keras \
  more-itertools

# install from conda:conda-forge
RUN /opt/conda/bin/conda install -y -c conda-forge \
  jupyter_contrib_nbextensions

# install from pip
RUN pip install \
  brotlipy \
  pendulum \
  feather-format \
  opencv-contrib-python \
  imgaug \
  tensorboardX \
  torchtext \
  fairseq \
  pytorch-pretrained-bert \
  easydict

# clean up
RUN /opt/conda/bin/conda clean -ya

# set default directory
WORKDIR /workspace

# create $NONROOT user
ARG NONROOT=nonroot
ARG UID=1000
ARG GID=1000
RUN apt-get install -y sudo
RUN groupadd -g $GID $NONROOT \
  && useradd -u $UID -g $GID -d /workspace -s /bin/bash $NONROOT \
    && echo "${NONROOT} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/1337-${NONROOT} \
    && chown -R $NONROOT:$NONROOT /workspace
# default user as $NONROOT
USER $NONROOT
