# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ab_glyph_rasterizer@0.1.10
	android_system_properties@0.1.6
	autocfg@1.5.1
	bitflags@2.13.2
	bumpalo@3.20.3
	bytemuck@1.25.2
	bytemuck_derive@1.12.1
	calloop-wayland-source@0.4.1
	calloop@0.14.5
	cc@1.11.1
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	chrono@0.4.45
	concurrent-queue@2.5.0
	core-foundation-sys@0.8.7
	crossbeam-utils@0.8.23
	cursor-icon@1.2.0
	downcast-rs@2.0.2
	equivalent@1.0.3
	errno@0.3.14
	find-msvc-tools@0.1.15
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	getopts@0.2.24
	greetd_ipc@0.10.3
	hashbrown@0.17.1
	hermit-abi@0.5.3
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	indexmap@2.14.2
	itoa@1.0.18
	js-sys@0.3.107
	lazy_static@1.5.1
	libc@0.2.191
	linux-raw-sys@0.12.1
	log@0.4.35
	memchr@2.8.3
	memmap2@0.9.12
	nix@0.31.3
	num-traits@0.2.19
	os_pipe@1.2.3
	owned_ttf_parser@0.25.1
	pin-project-lite@0.2.17
	pkg-config@0.3.34
	polling@3.11.0
	proc-macro2@1.0.107
	quick-xml@0.42.0
	quote@1.0.47
	rustix@1.1.6
	rusttype@0.9.3
	rustversion@1.0.23
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.154
	serde_spanned@1.1.3
	shlex@2.0.1
	slab@0.4.12
	smallvec@1.16.5
	smithay-client-toolkit@0.21.1
	syn@3.0.9
	thiserror-impl@2.0.21
	thiserror@2.0.21
	toml@1.2.1+spec-1.1.0
	toml_datetime@1.1.3+spec-1.1.0
	toml_parser@1.1.5+spec-1.1.0
	toml_writer@1.2.0+spec-1.1.0
	tracing-core@0.1.36
	tracing@0.1.44
	ttf-parser@0.25.1
	unicode-ident@1.0.27
	unicode-width@0.2.3
	wasm-bindgen-macro-support@0.2.130
	wasm-bindgen-macro@0.2.130
	wasm-bindgen-shared@0.2.130
	wasm-bindgen@0.2.130
	wayland-backend@0.3.17
	wayland-client@0.31.15
	wayland-csd-frame@0.3.0
	wayland-cursor@0.31.14
	wayland-protocols-experimental@20251230.0.3
	wayland-protocols-misc@0.3.12
	wayland-protocols-wlr@0.3.12
	wayland-protocols@0.32.13
	wayland-scanner@0.31.11
	wayland-sys@0.31.11
	windows-core@0.100.0
	windows-implement@0.100.0
	windows-interface@0.100.0
	windows-link@0.100.0
	windows-result@0.100.0
	windows-strings@0.100.0
	windows-sys@0.61.2
	winnow@1.0.5
	xcursor@0.3.11
	xkbcommon@0.9.0
	xkeysym@0.2.1
	zmij@1.0.23
"

RUST_MAX_VER="1.99.0"
RUST_MIN_VER="1.95.0"

inherit flag-o-matic cargo rust

DESCRIPTION="wlgreet"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/wlgreet"
SRC_URI="
	https://git.sr.ht/~kennylevinsen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"
RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+clang"

BDEPEND="
	virtual/pkgconfig
	clang? (
		llvm-core/clang
		|| (
			llvm-core/lld
			sys-devel/mold
		)
		llvm-core/llvm
	)
"
DEPEND="${BDEPEND}
	x11-libs/libxkbcommon
	>=gui-libs/greetd-0.6.1
	>=dev-libs/wayland-protocols-1.20
"

RDEPEND="
	>=gui-libs/greetd-0.6.1
	x11-libs/libxkbcommon
"

PATCHES=(
	"${FILESDIR}/wlgreet-refactor-migrate-to-smithay-client-toolkit-0.20-and-.patch"
	"${FILESDIR}/wlgreet-0.5.0-latest-crates.patch"
)

pkg_setup() {
	rust_pkg_setup
}

src_prepare() {
	default

	pushd "${ECARGO_VENDOR}" >/dev/null || die
	eapply "${FILESDIR}/wlgreet-0.5.0-transitive-crates.patch"
	popd >/dev/null || die
}

src_configure() {
	if use clang && ! tc-is-clang; then
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		strip-unsupported-flags
	elif ! use clang && ! tc-is-gcc; then
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		strip-unsupported-flags
	fi
}

src_compile() {
	cargo_src_compile
}
