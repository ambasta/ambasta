# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+completion docs +grapheme-clustering ime +notify +pgo xdg"

DEPEND="
	media-libs/fcft
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	x11-libs/libxkbcommon
	completion? ( app-shells/bash-completion )
	grapheme-clustering? ( dev-libs/libutf8proc )
	notify? ( x11-libs/libnotify )
	xdg? ( x11-misc/xdg-utils )
"
RDEPEND="${DEPEND}
	gui-apps/foot-terminfo"
BDEPEND="
	dev-libs/tllist
	dev-util/ninja
	dev-util/meson
	dev-libs/wayland-protocols
	docs? ( app-text/scdoc )"

S="${WORKDIR}/${PN}"

pkg_pretend() {
	if use pgo ; then
		if ! has usersanbox $FEATURES ; then
			die "You must enable usersandbox as wayland server can not run as root!"
		fi
	fi

	check-reqs_pkg_pretend
}

pkg_setup() {
	if use pgo ; then
		if ! has userpriv $FEATURES ; then
			eerror "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
		fi
	fi

	check-reqs_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}/guard-unittests-for-pgo.patch"

	eapply_user
}

src_configure() {
	local emesonargs=(
		-Dterminfo=disabled
		$(meson_feature docs)
		$(meson_use ime)
		$(meson_feature grapheme-clustering)
	)

	if use pgo; then
		emesonargs+=( -Db_pgo=generate )
	fi
	meson_src_configure
}

src_compile() {
	if use pgo; then
		virtx_cmd=virtx

		addpredict /root
	fi

	meson_src_compile

	if use pgo; then
		PROFILE_DIR=${BUILD_DOR:-${WORKDIR}/${P}-prof}"
		# cage
		XDG_RUNTIME_DIR="${PROFILE_DIR}" WLR_BACKENDS=headless cage "${srcdir}"/pgo/full-inner.sh "${srcdir}" "${blddir}"

		# sway
		# Generate sway config
		"${srcdir}"/pgo/full-headless-sway-inner.sh "${srcdir}" "${blddir}"
		XDG_RUNTIME_DIR="${PROFILE_DIR}" WLR_BACKENDS=headless sway -c "${sway_conf}"

		${BUILD_DIR}/foot --config=/dev/null --term=xterm sh -c "set-eux '${srcdir}/scripts/generate-alt-random-writes.py' ${SRC_DIR} ${BLD_DIR} ${PROFILE_DIR} cat ${PROFILE_DIR}"

		[ -f "${blddir}"/pgo-ok ] || exit 1

		BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"
		local mesonargs=(
			meson configure
			-Db_pgo=use
			"${BUILD_DIR}"
		)

		(
			echo "${mesonargs[@]}" >&2
			"${mesonargs[@]}"
		) || die

		meson_src_compile
	fi
}

src_install() {
	meson_src_install

	if use docs; then
		mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
