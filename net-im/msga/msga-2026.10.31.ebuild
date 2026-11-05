# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake desktop optfeature python-any-r1 xdg

MY_TAG=${PV//./-}
MBEDTLS_VERSION=3.6.7

DESCRIPTION="Fast native Slack client with optional Claude Code integration"
HOMEPAGE="https://msga.app/ https://github.com/punarinta/make-slack-great-again"
# The release page's "Source code (tar.gz)" download URL.
SRC_URI="
	https://github.com/punarinta/make-slack-great-again/archive/refs/tags/${MY_TAG}.tar.gz -> ${P}.tar.gz
	https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${MBEDTLS_VERSION}/mbedtls-${MBEDTLS_VERSION}.tar.bz2
"
S="${WORKDIR}/make-slack-great-again-${MY_TAG}"

# Includes upstream's modified Hunspell/stb and private miniaudio/Mbed TLS.
LICENSE="GPL-3+ GPL-2+ MIT MIT-0 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +wayland X"
REQUIRED_USE="|| ( wayland X )"
RESTRICT="!test? ( test )"

DEPEND="
	media-libs/freetype:2
	media-libs/harfbuzz:=
	sys-apps/dbus
	x11-libs/libxkbcommon
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libxcb:=[xkb]
		x11-libs/libxkbcommon[X]
		x11-libs/xcb-util-cursor
	)
"
RDEPEND="
	${DEPEND}
	app-misc/ca-certificates
	media-fonts/inter
	x11-misc/xdg-utils
"
BDEPEND="
	virtual/pkgconfig
	wayland? (
		dev-util/wayland-scanner
		>=dev-libs/wayland-protocols-1.32
	)
	test? (
		${PYTHON_DEPS}
		media-fonts/inter
	)
"

PATCHES=( "${FILESDIR}/${P}-test-includes.patch" )

pkg_setup() {
	if use test; then
		python-any-r1_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_SOURCE_DIR_MSGA_MBEDTLS="${WORKDIR}/mbedtls-${MBEDTLS_VERSION}"
		-DMSGA_BUNDLED_FONT_LIBS=OFF
		-DMSGA_BUILD_TESTS=$(usex test)
		-DMSGA_INSTALL_LAUNCHER=OFF
		-DMSGA_LINK_STRIP=OFF
		-DMSGA_SELF_UPDATE=OFF
		-DMSGA_SIZE_MAP=OFF
		-DMSGA_STATIC=OFF
		-DPLAT_WAYLAND=$(usex wayland)
		-DPLAT_X11=$(usex X)
		-DMSGA_HAVE_LLD=OFF
	)
	use test && mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )
	cmake_src_configure
}

src_compile() {
	if use test; then
		cmake_src_compile
	else
		cmake_src_compile msga
	fi
}

src_install() {
	dobin "${BUILD_DIR}/msga"
	domenu gfx/msga.desktop
	newicon -s 256 gfx/icon_256.png msga.png
	newicon -s scalable gfx/icon.svg msga.svg
	dodoc README.md THIRD_PARTY_LICENSES docs/SETUP_SLACK.md
}

src_test() {
	# Pixel/glyph assertions assume Inter; don't depend on the user's fonts.
	local -x MSGA_NEXT_FONT_DIRS="${BROOT}/usr/share/fonts/inter"
	cmake_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "colour emoji" media-fonts/noto-emoji
	optfeature "spell-check dictionaries" app-dicts/myspell-en
	optfeature "audio playback and recording" "media-video/pipewire[extra]" media-libs/libpulse media-sound/alsa-utils
	optfeature "additional audio codecs" media-video/ffmpeg
}
