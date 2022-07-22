FROM debian:latest

# build arguments
# ARG RELEASE
ARG DEBIAN_FRONTEND="noninteractive"
ENV PATH=/node_modules/.bin:$PATH

# set workdir
WORKDIR /src/forkboard

# install build dependencies
RUN \
	apt-get update \
	&& apt-get install -y \
	--no-install-recommends \
	ca-certificates \
	curl \
	git \
	npm \
	\
# cleanup
	\
	&& rm -rf \
		/src/* \
		/var/lib/apt/lists/* \
		/var/src/*

# fetch version file
RUN \
	set -ex \
	&& curl -o \
	/src/version_crypto.txt -L \
	"https://raw.githubusercontent.com/sparklyballs/versioning/master/version_crypto.txt"

# fetch source
RUN \
	. /src/version_crypto.txt \
	&& set -ex \
	&& mkdir -p /src/forkboard \
	&& curl -o \
		/src/forkboard.tar.gz -L \
		"https://github.com/aaroncarpenter/fork-board/archive/refs/tags/v${FORKBOARD_RELEASE}.tar.gz" \
	&& tar xf /src/forkboard.tar.gz -C \
		/src/forkboard --strip-components=1

## install electron packager
RUN \ 
	npm add electron-packager


# build package
RUN \
	set -ex \
	&& npm install \
	&& node_modules/.bin/electron-packager . forkboard --overwrite --linux --x64 --icon=assets/icons/fork-board-gray.png --prune=true --out=./out --ignore=^/assets/config

# copy local files
ADD forkboard.desktop /src/
ADD forkboard.sh /src/

# install package to /build
RUN \
	mkdir -p /build/opt/forkboard \
	&& cp -r out/forkboard-linux-x64/* /build/opt/forkboard \
	&& mkdir -p /build/opt/forkboard/resources/app/{assets/config,logs} \
	&& chmod a+rw -R /build/opt/forkboard/resources/app/{assets/config,logs} \
	&& chmod  a+rx /build/opt/forkboard/forkboard \
	&& install -vDm644 assets/icons/fork-board.png /build/usr/share/icons/hicolor/512x512/apps/forkboard.png \
	&& install -vDm755 /src/forkboard.sh /build/usr/bin/forkboard \
	&& install -vDm644 /src/forkboard.desktop -t /build/usr/share/applications
