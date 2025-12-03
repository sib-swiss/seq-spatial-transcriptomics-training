FROM rocker/rstudio:4.5.1

# Avoid cross-architecture contamination inside renv cache
ENV RENV_CONFIG_CACHE_ENABLED=FALSE

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxt6 \
    libgl1 \
    libcurl4-openssl-dev \
    libglpk-dev \
    libxml2-dev \
    libproj-dev \
    libudunits2-dev \
    libgdal-dev \
    tree \
    libcairo2-dev \
    libxt-dev \
    cmake \
    gdal-bin \
    libmagick++-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy renv lockfile
COPY renv.lock ./

# Install renv (auto-selects correct binary or source per architecture)
RUN Rscript -e 'install.packages("renv", repos="https://cloud.r-project.org")'

# Rebuild R package library from renv.lock
RUN Rscript -e 'renv::restore()'

# Install remaining packages
RUN Rscript -e 'install.packages("arrow", type="source")'
RUN Rscript -e 'BiocManager::install(c("Banksy","igraph","BayesSpace","nnSVG","RColorBrewer"), ask=FALSE)'
