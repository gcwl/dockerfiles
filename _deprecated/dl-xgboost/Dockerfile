ARG PREFIX
FROM ${PREFIX}/dl

# be root
USER root

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

# install from pip
RUN pip install \
  dask-xgboost \
  lightgbm \
  eli5

# clean up
RUN rm -rf /tmp/*
RUN /opt/conda/bin/conda clean -ya

# set default directory
WORKDIR /workspace
# set default user
USER $NONROOT
