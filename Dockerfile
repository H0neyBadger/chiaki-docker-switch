FROM docker.io/library/archlinux:latest

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=/opt/devkitpro/devkitARM
ENV DEVKITPPC=/opt/devkitpro/devkitPPC
ENV PATH="${PATH}:${DEVKITARM}/bin/:${DEVKITPPC}/bin/"

ENV WORKDIR="/build"
WORKDIR "${WORKDIR}"

RUN pacman-key --init
# Install devkitpro
# doc source :
# https://devkitpro.org/wiki/devkitPro_pacman

# First import the key which is used to validate the packages
RUN pacman-key --recv BC26F752D25B92CE272E0F44F7FD5492264BB9D0 --keyserver keyserver.ubuntu.com && \
        pacman-key --lsign BC26F752D25B92CE272E0F44F7FD5492264BB9D0

RUN pacman --noconfirm -U https://downloads.devkitpro.org/devkitpro-keyring.pkg.tar.xz
ADD devkit_repo ./devkit_repo
RUN cat ./devkit_repo >> /etc/pacman.conf

# Now resync the database and update installed packages.
# And install requirements
RUN pacman --noconfirm -Syu && \
    pacman --noconfirm -S \
        llvm \
        clang \
        lld \
        python \
        python-pip \
        python-virtualenv \
        squashfs-tools \
        base-devel \
        git \
        cmake \
        libx11 \
        vim \
        protobuf \
        python-protobuf \
        sfml \
        devkitARM \
        switch-pkg-config \
        devkitpro-pkgbuild-helpers \
        switch-dev \
        switch-zlib \
        switch-sdl2 \
        switch-freetype \
        switch-curl \
        switch-mesa \
        switch-glad \
        switch-glm \
        switch-libconfig \
        switch-sdl2_gfx \
        switch-sdl2_ttf \
        switch-sdl2_image \
        switch-sdl2_mixer \
        switch-libexpat \
        switch-bzip2 \
        switch-libopus \
        switch-ffmpeg \
        switch-mbedtls && \
  pacman --noconfirm -Sc

VOLUME ${WORKDIR}

# nxlink server port
EXPOSE 28771
ENTRYPOINT ["/bin/bash"]
