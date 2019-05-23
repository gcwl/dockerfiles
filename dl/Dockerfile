ARG WHOAMI
FROM ${WHOAMI}/apex-cmake

# install from conda
RUN /opt/conda/bin/conda install -y -c conda-forge \
  ipython \
  jupyter \
  jupyter_contrib_nbextensions

# install from pip
RUN pip install -U \
  cython \
  pytorch-ignite \
  scipy \
  feather-format \
  pandas \
  scikit-learn \
  matplotlib \
  bokeh \
  seaborn \
  scikit-image \
  imageio \
  imgaug \
  opencv-contrib-python \
  ftfy \
  spacy \
  nltk \
  pytorch-pretrained-bert \
  "dask[complete]" \
  joblib \
  ujson \
  easydict \
  tabulate \
  request

# clean up
RUN /opt/conda/bin/conda clean -ya

# set default directory
WORKDIR /workspace
