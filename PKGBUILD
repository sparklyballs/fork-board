# Maintainer: Sparklyballs

pkgname=ForkBoard
pkgname_src=fork-board
pkgver=0.7.0.r4.gfa729d1
pkgrel=1
pkgdesc='An ElectronJS Dashboard App to show wallets balances from Chia and Forks in one convenient location.'
arch=('x86_64')
url='https://github.com/aaroncarpenter/fork-board'
depends=('gtk3' 'nss')
makedepends=( 'git' 'npm' 'yarn')
source=(git+https://github.com/aaroncarpenter/fork-board.git 
	ForkBoard.desktop
	ForkBoard.sh)
sha256sums=('SKIP'
            '27ca14aeaa6abd956e5df7f0dd0289de5f367d20dd900c16a5cf1776b285a876'
            '77f7e6d7e6213f1191ff998f5897f688065e30ebf90b631d79617ccff1009ba8')
pkgver() {
  cd "$pkgname_src"
  git describe --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}
build() {
	cd ${pkgname_src}
	yarn add electron-packager
	yarn install
	node_modules/.bin/electron-packager . ${pkgname} --linux --amd64  --out dist/ --overwrite
}
package() {
	cd ${pkgname_src}
	mkdir -p "${pkgdir}/opt/${pkgname}"
	cp -r dist/${pkgname}-linux-x64/* "${pkgdir}/opt/${pkgname}"
	chmod -R 0777 "${pkgdir}/opt/${pkgname}"/resources
	chmod  a+rx "${pkgdir}/opt/${pkgname}"/${pkgname}
	install -vDm644 "assets/icons/${pkgname_src}.png" "${pkgdir}/usr/share/icons/hicolor/512x512/apps/${pkgname}.png"
	install -vDm755 "${srcdir}/${pkgname}.sh" "${pkgdir}/usr/bin/${pkgname}"
	install -vDm644 "${srcdir}"/${pkgname}.desktop -t "${pkgdir}"/usr/share/applications
}
