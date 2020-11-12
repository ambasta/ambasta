EAPI=7

PYTHON_COMPAT=( python3_{8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Per-application volume control and OSD for Linux desktops."
HOMEPAGE="https://buzz.github.io/volctl/"

SRC_URI="https://github.com/buzz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	media-sound/pulseaudio
	dev-python/pygobject"
DEPEND="dev-util/cmake ${RDEPEND}"

distutils_enable_tests pytest
