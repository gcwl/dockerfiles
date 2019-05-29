ARG FROM
FROM $FROM as lightgbm

# build lightgbm (with gpu support)
# https://lightgbm.readthedocs.io/en/latest/GPU-Tutorial.html#build-lightgbm
# https://github.com/Microsoft/LightGBM/blob/master/docker/gpu/dockerfile.gpu#L15
ENV CUDA_HOME /usr/local/cuda
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib
ENV OPENCL_LIBRARIES /usr/local/cuda/lib64
ENV OPENCL_INCLUDE_DIR /usr/local/cuda/include

# these packages are needed for building lightgbm
RUN apt-get update && apt-get install -y --no-install-recommends \
  nvidia-opencl-dev opencl-headers \
  libboost-dev libboost-system-dev libboost-filesystem-dev \
  && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# https://github.com/Microsoft/LightGBM/blob/master/docker/gpu/dockerfile.gpu#L60
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

WORKDIR /opt
# https://github.com/Microsoft/LightGBM/blob/master/docker/gpu/dockerfile.gpu#L84
RUN git clone --recursive https://github.com/microsoft/LightGBM \
  && mkdir -p /opt/LightGBM/build  && cd /opt/LightGBM/build \
  && cmake -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ .. \
  && make OPENCL_HEADERS=/usr/local/cuda/targets/x86_64-linux/include LIBOPENCL=/usr/local/cuda/targets/x86_64-linux/lib -j$(nproc) \
  && cd /opt/LightGBM/python-package && python setup.py install --precompile \
  && rm -rf /opt/LightGBM/build

WORKDIR /workspace
