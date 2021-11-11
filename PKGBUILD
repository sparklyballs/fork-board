pkgname=fork-board
pkgver=15.3.1
pkgrel=1
# _electronversion=13
pkgdesc='A small dashboard application to show balances of wallets from Chia and Forks.'
arch=('x86_64')
url='https://github.com/aaroncarpenter/fork-board'
depends=('gtk3' 'nss')
makedepends=('npm' 'yarn')
source=(git+https://github.com/aaroncarpenter/fork-board.git 
	fork-board.desktop
	fork-board.png
	fork-board.sh)
sha256sums=('SKIP'
            'fcd18467e6c96eca55d4a8caa5457c6bd2ce570ce43c2cb7d6902c3f0f93868e'
            'f7483ee8862732bab278d3b326ace2dee7cb1047c2891371cae4a9648739f0ea'
            'b64bb2efdf79cb3f58370ec4dc07a320cfe5171437835387d718f0c16d7787b8')
build() {
	cd ${pkgname}
	yarn add electron-packager
	yarn install
	node_modules/.bin/electron-packager . fork-board --linux --amd64  --out dist/ --overwrite
}
package() {
	cd ${pkgname}
	mkdir -p "${pkgdir}/opt/${pkgname}"
	cp -r dist/fork-board-linux-x64/* "${pkgdir}/opt/${pkgname}"
	chmod -R 0777 "${pkgdir}/opt/${pkgname}"/resources
	chmod  a+rx "${pkgdir}/opt/${pkgname}"/fork-board
	install -vDm644 "${srcdir}/fork-board.png" "${pkgdir}/usr/share/icons/hicolor/512x512/apps/${pkgname}.png"
	install -vDm755 "${srcdir}/${pkgname}.sh" "${pkgdir}/usr/bin/fork-board"
	install -vDm644 "${srcdir}"/${pkgname}.desktop -t "${pkgdir}"/usr/share/applications
}
