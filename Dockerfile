ARG DEBIAN_VERSION="bookworm-slim"
FROM debian:$DEBIAN_VERSION

# build arguments
ARG RELEASE
ARG DEBIAN_FRONTEND="noninteractive"
ENV PATH=/node_modules/.bin:$PATH

# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install build dependencies
RUN \
	apt-get update \
	&& apt-get install -y \
	--no-install-recommends \
	bzip2 \
	ca-certificates \
	curl \
	git \
	jq \
	npm \
	\
# cleanup
	\
	&& rm -rf \
		/src/* \
		/var/lib/apt/lists/* \
		/var/src/*

# fetch source
RUN \
	if [ -z ${RELEASE+x} ]; then \
	RELEASE=$(curl -u "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/aaroncarpenter/fork-board/releases/latest" \
	| jq -r ".tag_name"); \
	fi \
	&& git clone --branch "${RELEASE}" https://github.com/aaroncarpenter/fork-board.git /src/forkboard


# copy local files
COPY forkboard.desktop /src/
COPY forkboard.sh /src/

# set workdir
WORKDIR /src/forkboard

# build package
RUN \
	set -ex \
	&& npm install \
	&& node_modules/.bin/electron-packager . forkboard --overwrite --linux --x64 --icon=assets/icons/fork-board-gray.png --prune=true --out=./out --ignore=^/assets/config

# install package to /forkboard
RUN \
	mkdir -p /forkboard/opt/forkboard \
	&& cp -r out/forkboard-linux-x64/* /forkboard/opt/forkboard \
	&& mkdir -p /forkboard/opt/forkboard/resources/app/assets/config \
	&& mkdir -p /forkboard/opt/forkboard/resources/app/logs  \
	&& chmod a+rw -R /forkboard/opt/forkboard/resources/app/assets/config \
	&& chmod a+rw -R /forkboard/opt/forkboard/resources/app/logs \
	&& chmod  a+rx /forkboard/opt/forkboard/forkboard \
	&& install -vDm644 assets/icons/fork-board.png /forkboard/usr/share/icons/hicolor/512x512/apps/forkboard.png \
	&& install -vDm755 /src/forkboard.sh /forkboard/usr/bin/forkboard \
	&& install -vDm644 /src/forkboard.desktop -t /forkboard/usr/share/applications

# make build tarball
WORKDIR /
RUN \
        if [ -z ${RELEASE+x} ]; then \
        RELEASE=$(curl -u "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/aaroncarpenter/fork-board/releases/latest" \
        | jq -r ".tag_name"); \
        fi \
	&& mkdir -p /build \
	&& set -ex \
	&& tar -cjf "/build/forkboard-${RELEASE}.tar.gz" forkboard \
	&& chown -R 1000:1000 /build
 
# copy files out to /mnt
CMD ["cp", "-avr", "/build", "/mnt/"]
