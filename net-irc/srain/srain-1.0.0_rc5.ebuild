EAPI=7

MY_PV="${PV/_/}"

DESCRIPTION="Modern, beautiful IRC client written in GTK+ 3"
HOMEPAGE="https://github.com/SrainApp/srain"
SRC_URI="https://github.com/SilverRainZ/${PN}/archive/${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-devel/gettext
	dev-libs/glib:2
	net-libs/glib-networking
	>=x11-libs/gtk+-3.18
	net-libs/libsoup
	dev-libs/libconfig
	app-crypt/libsecret"

BDEPEND="
	sys-apps/coreutils
	sys-devel/gcc
	sys-devel/make
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"
