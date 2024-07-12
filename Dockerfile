FROM python:2-slim-buster
LABEL maintainer="Gaurav Mankotia <gauravmankotiarocks@gmail.com>"

# ---------------------------------------------------------------------
# Build + install usd
WORKDIR /usr/src/usd

# Configuration
ARG USD_RELEASE="20.05"
ARG USD_INSTALL="/usr/local/usd"
ENV PYTHONPATH="${PYTHONPATH}:${USD_INSTALL}/lib/python"
ENV PATH="${PATH}:${USD_INSTALL}/bin"

# Dependencies
RUN apt-get -qq update && apt-get install -y --no-install-recommends \
    git build-essential cmake nasm \
    libglew-dev libxrandr-dev libxcursor-dev libxinerama-dev libxi-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Build + install USD
RUN git clone --branch "v${USD_RELEASE}" --depth 1 https://github.com/PixarAnimationStudios/USD.git /usr/src/usd
RUN python ./build_scripts/build_usd.py -v --no-usdview "${USD_INSTALL}" && \
  rm -rf "${USD_REPO}" "${USD_INSTALL}/build" "${USD_INSTALL}/src"

# ---------------------------------------------------------------------
# Build + install usd_from_gltf
WORKDIR /usr/src/ufg

# Configuration
ARG UFG_RELEASE="3bf441e0eb5b6cfbe487bbf1e2b42b7447c43d02"
ARG UFG_SRC="/usr/src/ufg"
ARG UFG_INSTALL="/usr/local/ufg"
ENV LD_LIBRARY_PATH="${USD_INSTALL}/lib:${UFG_SRC}/lib"
ENV PATH="${PATH}:${UFG_INSTALL}/bin"
ENV PYTHONPATH="${PYTHONPATH}:${UFG_INSTALL}/python"

RUN git init && \
    git remote add origin https://github.com/google/usd_from_gltf.git && \
    git fetch --depth 1 origin "${UFG_RELEASE}" && \
    git checkout FETCH_HEAD && \
    python "${UFG_SRC}/tools/ufginstall/ufginstall.py" -v "${UFG_INSTALL}" "${USD_INSTALL}" && \
    cp -r "${UFG_SRC}/tools/ufgbatch" "${UFG_INSTALL}/python" && \
    rm -rf "${UFG_SRC}" "${UFG_INSTALL}/build" "${UFG_INSTALL}/src"

RUN mkdir /usr/app
WORKDIR /usr/app

COPY input-file.glb /usr/app

ENTRYPOINT echo "Glb to usdz converter :" && \
    usd_from_gltf /usr/app/input-file.glb input-file.usdz