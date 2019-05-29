# ============================
# --target pytorch
# ============================
# https://hub.docker.com/r/nvidia/cuda/
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/10.0/devel/cudnn7/Dockerfile
ARG BASE_IMAGE=nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04
FROM $BASE_IMAGE as pytorch

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# install tools from apt-get
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  gcc \
  g++ \
  tmux \
  vim \
  git \
  curl \
  wget \
  ca-certificates \
  libjpeg-dev \
  libpng-dev \
  && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# build cmake, cmake from apt-get is outdated
WORKDIR /tmp
RUN git clone https://github.com/Kitware/CMake.git \
  && cd /tmp/CMake \
  && ./bootstrap && make && make install \
  && rm -rf /tmp/*

# download/install miniconda
RUN curl -o ~/miniconda.sh -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && chmod +x ~/miniconda.sh \
  && ~/miniconda.sh -b -p /opt/conda \
  && rm ~/miniconda.sh
# prepend conda to $PATH
ENV PATH /opt/conda/bin:$PATH

# install python packages from conda:main
ARG PYTHON_VERSION=3.6
RUN /opt/conda/bin/conda install -y \
  python=$PYTHON_VERSION \
  cython \
  ipython \
  numpy \
  numba \
  numexpr \
  bottleneck \
  scipy \
  mkl \
  mkl-include \
  typing \
  ninja \
  && /opt/conda/bin/conda clean -ya

# install pytorch from conda:pytorch
# https://anaconda.org/pytorch/repo
RUN /opt/conda/bin/conda install -y -c pytorch \
  magma-cuda100 \
  pytorch \
  ignite \
  torchvision \
  && /opt/conda/bin/conda clean -ya

# create/set directory
WORKDIR /workspace



# ============================
# --target apex
# ============================
FROM pytorch as apex

# install nvidia/apex
# https://github.com/NVIDIA/apex/tree/master/examples/docker
# Base image must at least have pytorch and CUDA installed.
# ==========================================================
# make sure we don't overwrite some existing directory called "apex"
WORKDIR /tmp/unique_for_apex
# uninstall Apex if present, twice to make absolutely sure :)
RUN pip uninstall -y apex || : && pip uninstall -y apex || :
# SHA is something the user can touch to force recreation of this Docker layer,
# and therefore force cloning of the latest version of Apex
RUN SHA=ToUcHMe git clone https://github.com/NVIDIA/apex.git \
  && cd apex \
  && pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" . \
  && rm -rf /tmp/*

# set default directory
WORKDIR /workspace



# ============================
# --target dml
# ============================
FROM apex as dml

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
  more-itertools \
  && /opt/conda/bin/conda clean -ya

# install from conda:conda-forge
RUN /opt/conda/bin/conda install -y -c conda-forge \
  jupyter_contrib_nbextensions \
  && /opt/conda/bin/conda clean -ya

# install from pip
RUN pip install -v --no-cache-dir \
  brotlipy \
  pendulum \
  feather-format \
  dash \
  opencv-contrib-python \
  imgaug \
  tensorboardX \
  torchtext \
  fairseq \
  pytorch-pretrained-bert \
  easydict
# xgboost \
# dask-xgboost \
# lightgbm \
# eli5 \

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

# build xgboost (with gpu support)
# https://xgboost.readthedocs.io/en/latest/build.html#building-with-gpu-support
# pick one of the following build method:
# 1/ no gpu support
# cmake .. && make -j4
# 2/ with single gpu support
# cmake .. -DUSE_CUDA=ON && make -j4
# 3/ with multi-gpu support (need to install nccl2 from https://developer.nvidia.com/nccl)
# cmake .. -DUSE_CUDA=ON -DUSE_NCCL=ON -DNCCL_ROOT=/path/to/nccl2 && make -j4
WORKDIR /opt
RUN git clone --recursive https://github.com/dmlc/xgboost \
  && mkdir -p /opt/xgboost/build && cd /opt/xgboost/build \
  && cmake .. -DUSE_CUDA=ON && make -j$(nproc) \
  && cd /opt/xgboost/python-package && python setup.py install \
  && rm -rf /opt/xgboost/build

# install from pip
RUN pip install -v --no-cache-dir dask-xgboost eli5

WORKDIR /workspace



# ============================
# --target cudml
# ============================
FROM dml as cudml

# install from conda
RUN /opt/conda/bin/conda install -y \
  -c defaults -c nvidia -c rapidsai -c pytorch -c numba -c conda-forge \
  cudf \
  cuml \
  dask-cuda \
  dask-cudf \
  dask-cuml \
  && /opt/conda/bin/conda clean -ya
