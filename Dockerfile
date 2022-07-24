ARG DEBIAN_VERSION="bullseye-slim"
FROM debian:$DEBIAN_VERSION

# build arguments
# ARG RELEASE
ARG DEBIAN_FRONTEND="noninteractive"
ENV PATH=/node_modules/.bin:$PATH

# install build dependencies
RUN \
	apt-get update \
	&& apt-get install -y \
	--no-install-recommends \
	bzip2 \
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
	/tmp/version_crypto.txt -L \
	"https://raw.githubusercontent.com/sparklyballs/versioning/master/version_crypto.txt"

# fetch source
RUN \
	. /tmp/version_crypto.txt \
	&& set -ex \
	&& mkdir -p /src/forkboard \
	&& curl -o \
		/src/forkboard-${FORKBOARD_RELEASE}.tar.gz -L \
		"https://github.com/aaroncarpenter/fork-board/archive/refs/tags/v${FORKBOARD_RELEASE}.tar.gz" \
	&& tar xf /src/forkboard-${FORKBOARD_RELEASE}.tar.gz -C \
		/src/forkboard --strip-components=1

# copy local files
ADD forkboard.desktop /src/
ADD forkboard.sh /src/

# set workdir
WORKDIR /src/forkboard

# build package
RUN \
	set -ex \
	&& npm add electron-packager \
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
RUN \
	. /tmp/version_crypto.txt \
	&& cd / \
	&& mkdir -p /build \
	&& set -ex \
	&& tar -cjf /build/forkboard-${FORKBOARD_RELEASE}.tar.gz forkboard/
 
# copy files out to /mnt
CMD ["cp", "-avr", "/build", "/mnt/"]
