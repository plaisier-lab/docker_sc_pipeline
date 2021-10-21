FROM ubuntu:latest
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
MAINTAINER Chris Plaisier <plaisier@asu.edu>, Samantha O'Connor <saoconn1@asu.edu>

RUN apt-get update

RUN apt-get install --yes software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

RUN add-apt-repository "deb [trusted=yes] https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/"

RUN apt-get update

# Turn off interactive installation features
ENV DEBIAN_FRONTEND=noninteractive

# Prepare Ubuntu by installing necessary dependencies
RUN apt-get install --yes \
 build-essential \
 gcc-multilib \
 apt-utils \
 zlib1g-dev \
 vim-common \
 wget \
 python3 \
 python3-pip \
 git \
 pigz \
 r-base \
 r-base-dev \
 libxml2 \
 libxml2-dev

# Install loomR to convert Seurat to loom files
RUN apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libssh2-1-dev
RUN R -e "install.packages('devtools')"
RUN R -e "devtools::install_github('hhoeflin/hdf5r')"
RUN R -e "devtools::install_github('mojaveazure/loomR', ref = 'develop')"
RUN R -e "devtools::install_github('plaisier-lab/CONICSmat')"

# Install R packages needed to run pipeline
WORKDIR /
RUN R -e "install.packages(c('getopt','dplyr','Seurat','SeuratDisk','patchwork','ggplot2','grid','gridExtra','writexl','data.table','readr','verification','MCMCpack','tidyr','beanplot','mixtools','pheatmap','zoo','squash'), repos = 'http://cran.us.r-project.org')"

# Install Bioconductor pacakges
RUN R -e "source('https://bioconductor.org/biocLite.R')"
RUN R -e "BiocManager::install(c('biomaRt'))"

