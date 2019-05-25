ARG WHOAMI
FROM ${WHOAMI}/dl-xgboost

# install from conda
RUN /opt/conda/bin/conda install -y \
  -c defaults -c nvidia -c rapidsai -c pytorch -c numba -c conda-forge \
  cudf \
  cuml \
  dask-cuda \
  dask-cudf \
  dask-cuml

# clean up
RUN rm -rf /tmp/*
RUN /opt/conda/bin/conda clean -ya

# set default directory
WORKDIR /workspace
