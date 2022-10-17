EAPI=7

PYTHON_COMPAT=( python3_{10,11} pypy3 )

inherit distutils-r1 gnome2-utils

DESCRIPTION="Per-application volume control and OSD for Linux desktops."
HOMEPAGE="https://buzz.github.io/volctl/"

SRC_URI="https://github.com/buzz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

# glib for glib-compile-schemas at build time, needed at runtime anyways
COMMON_DEPEND="
	dev-libs/glib:2
"

RDEPEND="
	media-sound/pulseaudio
	dev-python/pygobject"

DEPEND="${RDEPEND} ${COMMON_DEPEND}"

distutils_enable_tests pytest

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
