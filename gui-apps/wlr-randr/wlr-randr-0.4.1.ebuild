EAPI=8

inherit meson

DESCRIPTION="Utility to manage outputs of a Wayland compositor"
HOME_PAGE="https://sr.ht/~emersion/wlr-randr/"

SRC_URI="https://git.sr.ht/~emersion/${PN}/refs/download/v${PV}/${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT=0

DEPEND="dev-libs/wayland"

src_configure() {
	local emesonargs=(
		-Dwerror=true
	)
	meson_src_configure
}
