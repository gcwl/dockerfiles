ARG WHOAMI
FROM ${WHOAMI}/apex-cmake

# install from conda
RUN /opt/conda/bin/conda install -y \
  -c conda-forge \
  ipython \
  jupyter \
  jupyter_contrib_nbextensions

RUN /opt/conda/bin/conda install -y \
  -c defaults -c nvidia -c rapidsai -c pytorch -c numba -c conda-forge \
  cudf=0.7 \
  cuml=0.7

# install from pip
RUN pip install -U \
  cython \
  pytorch-ignite \
  scipy \
  feather-format \
  pandas \
  scikit-learn \
  scikit-image \
  matplotlib \
  bokeh \
  seaborn \
  opencv-contrib-python \
  imageio \
  spacy \
  nltk \
  pytorch-pretrained-bert \
  ujson \
  easydict \
  tabulate \
  joblib \
  request

# build xgboost (with gpu support)
# https://xgboost.readthedocs.io/en/latest/build.html#building-with-gpu-support
WORKDIR /opt
RUN git clone --recursive https://github.com/dmlc/xgboost
RUN mkdir -p /opt/xgboost/build
WORKDIR /opt/xgboost/build
## pick one of the following build method
# 1/ no gpu support
# RUN cmake .. && make -j4
# 2/ with single gpu support
RUN cmake .. -DUSE_CUDA=ON && make -j4
# 3/ with multi-gpu support (need to install nccl2 from https://developer.nvidia.com/nccl)
# RUN cmake .. -DUSE_CUDA=ON -DUSE_NCCL=ON -DNCCL_ROOT=/path/to/nccl2 && make -j4
# install xgboost for python
WORKDIR /opt/xgboost/python-package
RUN python setup.py install

# TODO build lightgbm
# https://github.com/Microsoft/LightGBM/blob/master/docs/Installation-Guide.rst#build-gpu-version
# https://pypi.org/project/lightgbm/
# WORKDIR /opt
# pip install lightgbm --install-option=--gpu

# clean up
RUN rm -rf /tmp/*
RUN /opt/conda/bin/conda clean -ya

# set default directory
WORKDIR /workspace
