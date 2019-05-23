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
    opencv-contrib-python \
    scikit-image \
    imageio \
    ftfy \
    spacy \
    nltk \
    pytorch-pretrained-bert \
    ujson \
    easydict \
    tabulate \
    joblib \
    request

# clean up
RUN /opt/conda/bin/conda clean -ya

# set default directory
WORKDIR /workspace
