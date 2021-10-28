pkgname=fork-board
pkgver=0.5.0
pkgrel=1
_electronversion=13
pkgdesc='A small dashboard application to show balances of wallets from Chia and Forks.'
arch=('x86_64')
url='https://github.com/aaroncarpenter/fork-board'
depends=("electron$_electronversion" 'gtk3' 'nss')
makedepends=('npm' 'yarn')
source=(${pkgname}-${pkgver}.tar.gz::https://github.com/aaroncarpenter/fork-board/archive/refs/tags/v${pkgver}.tar.gz)
sha256sums=('4a213ee18331704dfd3eea54115b8758be9e53b7c0c5e8c292096b1287e17e51')
build() {
	cd fork-board-${pkgver}
	yarn add electron-packager
	yarn install
	node_modules/.bin/electron-packager . fork-board --linux --amd64  --out dist/ --overwrite
}
package() {
	cd fork-board-${pkgver}
	mkdir -p "${pkgdir}/opt/${pkgname}"
	cp -r dist/fork-board-linux-x64/* "${pkgdir}/opt/${pkgname}"
	chmod -R a+rx "${pkgdir}/opt/${pkgname}"
}
