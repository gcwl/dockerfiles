ARG FROM
FROM $FROM as xgboost

# build xgboost (with gpu support)
# https://xgboost.readthedocs.io/en/latest/build.html#building-with-gpu-support
# pick one of the following build method:
# 1/ no gpu support
# cmake .. && make -j4
# 2/ with single gpu support
# cmake .. -DUSE_CUDA=ON && make -j4
# 3/ with multi-gpu support (need to install nccl2 from https://developer.nvidia.com/nccl)
# cmake .. -DUSE_CUDA=ON -DUSE_NCCL=ON -DNCCL_ROOT=/path/to/nccl2 && make -j4
WORKDIR /tmp
RUN git clone --recursive https://github.com/dmlc/xgboost \
  && mkdir -p /tmp/xgboost/build && cd /tmp/xgboost/build \
  && cmake .. -DUSE_CUDA=ON && make -j4 \
  && cd /tmp/xgboost/python-package && python setup.py install \
  && rm -rf /tmp/*

# install from pip
RUN pip install -v --no-cache-dir dask-xgboost
