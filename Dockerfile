FROM archlinux:latest

# build arguments
# ARG RELEASE
ENV PATH=/node_modules/.bin:$PATH

# install dependencies
RUN \
    pacman -Syyu \
    --noconfirm \
        dpkg \
        fakeroot \
        git \
        glib2 \
        gtk3 \
        libffi \
        nano \
        npm \
        nss \
        yarn

RUN \
    yarn add \
        electron \
        electron-builder \
        electron-packager \
        electron-installer-linux \
        --dev


WORKDIR /src/fork-board
RUN \
    git clone https://github.com/aaroncarpenter/fork-board \
        /src/fork-board \
    && set -ex \
    && yarn install \
    && electron-packager . fork-board --linux --amd64  --out dist/ --overwrite
