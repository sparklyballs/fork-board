# Maintainer: Sparklyballs

pkgname=forkboard
_pkgname_src=fork-board
pkgver=1.0.0
pkgrel=1
pkgdesc='An ElectronJS Dashboard App to show wallets balances from Chia and Forks in one convenient location.'
arch=('x86_64')
provides=("${pkgname}")
conflicts=("${pkgname}")
url='https://github.com/aaroncarpenter/fork-board'
depends=('gtk3' 'nss')
makedepends=( 'git' 'npm' 'yarn')
source=(${_pkgname_src}-${pkgver}.tar.gz::https://github.com/aaroncarpenter/fork-board/archive/refs/tags/v${pkgver}.tar.gz 
	forkboard.desktop
	forkboard.sh)
sha256sums=('c3fd252e29cf5d7846b00ad58a02b10f5c2a00d0bf7783793e0e7f04b6ea82a5'
            '20f8f8e3b757c7450be207ecc5a976e2b405cae20ea3e1290c1856d9c2f324a9'
            '81927d6ae46b4b4ab49bdfc798b1910d70b422adbd2d589501279155f6da3c90')
build() {
	cd ${_pkgname_src}-${pkgver}
	yarn add electron-packager
	yarn install
	node_modules/.bin/electron-packager . ${pkgname} --linux --amd64  --out dist/ --overwrite
}
package() {
	cd ${_pkgname_src}-${pkgver}
	mkdir -p "${pkgdir}/opt/${pkgname}"
	cp -r dist/${pkgname}-linux-x64/* "${pkgdir}/opt/${pkgname}"
	mkdir -p "${pkgdir}/opt/${pkgname}"/resources/app/assets/config
        chmod a+rw -R "${pkgdir}/opt/${pkgname}"/resources/app/assets/config
	chmod  a+rx "${pkgdir}/opt/${pkgname}"/${pkgname}
	install -vDm644 "assets/icons/${_pkgname_src}.png" "${pkgdir}/usr/share/icons/hicolor/512x512/apps/${pkgname}.png"
	install -vDm755 "${srcdir}/${pkgname}.sh" "${pkgdir}/usr/bin/${pkgname}"
	install -vDm644 "${srcdir}"/${pkgname}.desktop -t "${pkgdir}"/usr/share/applications
}
