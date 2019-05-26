ARG FROM
FROM $FROM as lightgbm

WORKDIR /opt

# https://lightgbm.readthedocs.io/en/latest/GPU-Tutorial.html#build-lightgbm
# https://github.com/Microsoft/LightGBM/blob/master/docker/gpu/dockerfile.gpu

RUN apt-get update && apt-get install -y --no-install-recommends \
  nvidia-opencl-dev opencl-headers \
  libboost-dev libboost-system-dev libboost-filesystem-dev \
  && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# if you have installed NVIDIA CUDA to a customized location,
# you should specify paths to OpenCL headers and library like the following:
# cmake -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ ..
RUN git clone --recursive https://github.com/microsoft/LightGBM \
  && mkdir -p /opt/LightGBM/build  && cd /opt/LightGBM/build \
  && cmake -DUSE_GPU=1 .. && make -j$(nproc) \
  && cd /opt/LightGBM/python-package && python setup.py install --precompile \
  && rm -rf /opt/LightGBM/build

WORKDIR /workspace
