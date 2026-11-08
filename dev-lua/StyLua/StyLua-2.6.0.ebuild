# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(lua5-{1..4} luajit)

CRATES="
	aho-corasick@1.1.5
	alloca@0.4.0
	anes@0.2.1
	anstream@1.0.0
	anstyle@1.0.14
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anyhow@1.0.104
	assert_cmd@2.2.2
	assert_fs@1.1.4
	autocfg@1.5.1
	bitflags@2.13.2
	borrow-or-share@0.2.4
	borsh@1.8.1
	bstr@1.13.1
	bumpalo@3.20.3
	bytecount@0.6.9
	bytes@1.12.1
	cast@0.3.0
	cc@1.11.1
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	ciborium@0.2.2
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	clap@4.6.7
	clap_builder@4.6.7
	clap_derive@4.6.7
	clap_lex@1.1.1
	colorchoice@1.0.5
	console@0.16.6
	convert_case@0.12.0
	criterion@0.8.2
	criterion-plot@0.8.2
	crossbeam-channel@0.5.17
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	crunchy@0.2.4
	derive_more@2.1.1
	derive_more-impl@2.1.1
	difflib@0.4.0
	ec4rs@1.2.0
	either@1.19.0
	encode_unicode@1.0.0
	env_filter@2.0.0
	env_logger@0.11.11
	equivalent@1.0.3
	errno@0.3.14
	fastrand@2.5.0
	find-msvc-tools@0.1.15
	fluent-uri@0.4.1
	full_moon@3.0.0
	full_moon_derive@0.11.0
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	getrandom@0.4.3
	globset@0.4.21
	globwalk@0.9.1
	half@2.7.1
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.5.3
	ignore@0.4.34
	indexmap@2.14.2
	insta@1.49.0
	is_terminal_polyfill@1.70.2
	itertools@0.15.0
	itoa@1.0.18
	js-sys@0.3.107
	lazy_static@1.5.1
	libc@0.2.191
	linux-raw-sys@0.12.1
	log@0.4.35
	lsp-server@0.10.0
	lsp-textdocument@0.5.0
	lsp-types@0.97.0
	memchr@2.8.3
	num-traits@0.2.19
	num_cpus@1.17.0
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	oorandom@11.1.5
	page_size@0.6.0
	paste@1.0.15
	pin-project-lite@0.2.17
	plotters@0.3.7
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	predicates@3.1.4
	predicates-core@1.0.10
	predicates-tree@1.0.13
	proc-macro2@1.0.107
	quote@1.0.47
	r-efi@7.1.0
	rayon@1.12.0
	rayon-core@1.13.0
	ref-cast@1.0.27
	ref-cast-impl@1.0.27
	regex@1.13.1
	regex-automata@0.4.18
	regex-syntax@0.8.11
	rustc_version@0.4.1
	rustix@1.1.6
	rustversion@1.0.23
	same-file@1.0.6
	semver@1.0.28
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.154
	serde_repr@0.1.21
	serde_spanned@1.1.3
	shlex@2.0.1
	similar@3.2.1
	slab@0.4.12
	smol_str@0.3.7
	strsim@0.11.1
	strum@0.28.0
	strum_macros@0.28.0
	syn@3.0.9
	tempfile@3.27.0
	termtree@1.0.0
	thiserror@2.0.21
	thiserror-impl@2.0.21
	threadpool@1.8.1
	tinytemplate@1.2.1
	toml@1.2.1+spec-1.1.0
	toml_datetime@1.1.3+spec-1.1.0
	toml_parser@1.1.5+spec-1.1.0
	toml_writer@1.2.0+spec-1.1.0
	unicode-ident@1.0.27
	unicode-segmentation@1.13.3
	unicode-width@0.2.3
	unicode-xid@0.2.6
	utf8parse@0.2.2
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasm-bindgen@0.2.130
	wasm-bindgen-macro@0.2.130
	wasm-bindgen-macro-support@0.2.130
	wasm-bindgen-shared@0.2.130
	web-sys@0.3.107
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-link@0.100.0
	windows-sys@0.61.2
	winnow@1.0.5
	zerocopy@0.8.63
	zerocopy-derive@0.8.63
	zmij@1.0.23
"

RUST_MAX_VER="1.99.0"
RUST_MIN_VER="1.89.0"

inherit cargo lua

DESCRIPTION="A Lua code formatter"
HOMEPAGE="https://github.com/JohnnyMorganz/StyLua"
SRC_URI="https://github.com/JohnnyMorganz/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="MPL-2.0"
# Dependent crates (choosing MIT where dual-licensed).
LICENSE+=" Apache-2.0 MIT MIT-0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-dependencies.patch" )

pkg_setup() {
	rust_pkg_setup
}

src_prepare() {
	default

	pushd "${ECARGO_VENDOR}" >/dev/null || die
	eapply "${FILESDIR}/${P}-crate-compat.patch"
	popd >/dev/null || die
}

src_configure() {
	local myfeatures=()

	# Map enabled LUA_TARGETS -> Cargo features via a function
	lua_add_features() {
		case ${ELUA} in
			lua5.1) : ;; # 5.1 is implicit with --no-default-features
			lua5.2) myfeatures+=(lua52) ;;
			lua5.3) myfeatures+=(lua53) ;;
			lua5.4) myfeatures+=(lua54) ;;
			luajit) myfeatures+=(luajit) ;;
			*) die "Unknown ELUA=${ELUA}" ;;
		esac
	}

	# Run once per enabled implementation (ELUA is set each time)
	lua_foreach_impl lua_add_features

	if ! use lua_targets_lua5-1 \
		&& ! use lua_targets_lua5-2 \
		&& ! use lua_targets_lua5-3 \
		&& ! use lua_targets_lua5-4 \
		&& ! use lua_targets_luajit; then
		die "Enable at least one LUA_TARGETS (lua5-1..5-4 or luajit)"
	fi

	cargo_src_configure --no-default-features
}
