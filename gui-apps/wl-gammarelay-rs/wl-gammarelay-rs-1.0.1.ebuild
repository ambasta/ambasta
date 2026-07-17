# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstyle@1.0.14
	anyhow@1.0.103
	autocfg@1.5.1
	bitflags@2.13.1
	bytemuck@1.25.1
	cfg-if@1.0.4
	cfg_aliases@0.1.1
	clap@4.6.2
	clap_builder@4.6.2
	clap_derive@4.6.1
	clap_lex@1.1.0
	equivalent@1.0.2
	hashbrown@0.17.1
	heck@0.5.0
	indexmap@2.14.0
	libc@0.2.186
	memchr@2.8.3
	memmap2@0.9.11
	memoffset@0.9.1
	nix@0.28.0
	proc-macro-crate@3.5.0
	proc-macro2@1.0.106
	quick-xml@0.37.5
	quote@1.0.46
	serde_core@1.0.228
	serde_derive@1.0.228
	shmemfdrs2@1.0.0
	syn@2.0.119
	thiserror-impl@1.0.69
	thiserror@1.0.69
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.25.13+spec-1.1.0
	toml_parser@1.1.2+spec-1.1.0
	unicode-ident@1.0.24
	wayrs-client@1.3.1
	wayrs-core@1.0.5
	wayrs-proto-parser@3.0.1
	wayrs-protocols@0.14.11+1.45
	wayrs-scanner@0.15.4
	winnow@1.0.4
"

declare -A GIT_CRATES=(
	[rustbus]='https://github.com/KillingSpark/rustbus;5875f1fefc054ed4e2d91641f59a55b9eaee5be9;rustbus-%commit%/rustbus'
	[rustbus_derive]='https://github.com/KillingSpark/rustbus;5875f1fefc054ed4e2d91641f59a55b9eaee5be9;rustbus-%commit%/rustbus_derive'
	[rustbus-service]='https://github.com/MaxVerevkin/rustbus-service;1bd3aef5fe2a646685c8e640c0f67a645eeaf41d;rustbus-service-%commit%'
	[rustbus-service-macros]='https://github.com/MaxVerevkin/rustbus-service;1bd3aef5fe2a646685c8e640c0f67a645eeaf41d;rustbus-service-%commit%/rustbus-service-macros'
)

RUST_MIN_VER="1.85.0"

inherit cargo

DESCRIPTION="Control display temperature and brightness under Wayland via D-Bus"
HOMEPAGE="https://github.com/MaxVerevkin/wl-gammarelay-rs"
SRC_URI="
	https://github.com/MaxVerevkin/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-3.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-apps/dbus"

PATCHES=(
	"${FILESDIR}/${P}-dependencies.patch"
)

QA_FLAGS_IGNORED="usr/bin/${PN}"

DOCS=( README.md )

src_prepare() {
	default

	# Let Portage control LTO, stripping, and split-debug handling.
	sed -i -e '/^lto = /d' -e '/^strip = /d' Cargo.toml || die
}

src_install() {
	cargo_src_install
	einstalldocs

	docinto examples
	dodoc scripts/README.md scripts/auto-temperature.py scripts/toggle-invert-display.sh
}
