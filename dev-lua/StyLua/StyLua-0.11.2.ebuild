# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(lua5-{1..2})

CRATES="
aho-corasick-0.7.18
ansi_term-0.11.0
anyhow-1.0.44
atty-0.2.14
autocfg-1.0.1
bitflags-1.3.2
bstr-0.2.16
bumpalo-3.7.0
bytecount-0.5.1
cast-0.2.7
cfg-if-1.0.0
clap-2.33.3
console-0.14.1
convert_case-0.4.0
criterion-0.3.5
criterion-plot-0.4.4
crossbeam-channel-0.5.1
crossbeam-deque-0.8.1
crossbeam-epoch-0.9.5
crossbeam-utils-0.8.5
csv-1.1.6
csv-core-0.1.10
derive_more-0.99.16
dtoa-0.4.8
either-1.6.1
encode_unicode-0.3.6
fnv-1.0.7
full_moon-0.14.0
full_moon_derive-0.9.0
globset-0.4.8
half-1.7.1
hashbrown-0.11.2
heck-0.3.3
hermit-abi-0.1.19
ignore-0.4.18
indexmap-1.7.0
insta-1.8.0
itertools-0.10.1
itoa-0.4.8
js-sys-0.3.55
lazy_static-1.4.0
libc-0.2.102
linked-hash-map-0.5.4
log-0.4.14
memchr-2.4.1
memoffset-0.6.4
num-traits-0.2.14
num_cpus-1.13.0
once_cell-1.8.0
oorandom-11.1.3
paste-0.1.18
paste-impl-0.1.18
peg-0.7.0
peg-macros-0.7.0
peg-runtime-0.7.0
pest-2.1.3
plotters-0.3.1
plotters-backend-0.3.2
plotters-svg-0.3.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.19
proc-macro2-1.0.29
quote-1.0.9
rayon-1.5.1
rayon-core-1.9.1
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
rustc_version-0.3.3
rustc_version-0.4.0
ryu-1.0.5
same-file-1.0.6
scopeguard-1.1.0
semver-0.11.0
semver-1.0.4
semver-parser-0.10.2
serde-1.0.130
serde_cbor-0.11.2
serde_derive-1.0.130
serde_json-1.0.68
serde_yaml-0.8.21
similar-1.3.0
smol_str-0.1.18
strsim-0.8.0
structopt-0.3.23
structopt-derive-0.4.16
stylua-0.11.2
syn-1.0.76
terminal_size-0.1.17
textwrap-0.11.0
thread_local-1.1.3
threadpool-1.8.1
tinytemplate-1.2.1
toml-0.5.8
ucd-trie-0.1.3
unicode-segmentation-1.8.0
unicode-width-0.1.8
unicode-xid-0.2.2
uuid-0.8.2
vec_map-0.8.2
version_check-0.9.3
walkdir-2.3.2
wasm-bindgen-0.2.78
wasm-bindgen-backend-0.2.78
wasm-bindgen-macro-0.2.78
wasm-bindgen-macro-support-0.2.78
wasm-bindgen-shared-0.2.78
web-sys-0.3.55
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
yaml-rust-0.4.5
"

RUST_MAX_VER="1.82.0"
RUST_MIN_VER="1.71.1"

inherit cargo lua toolchain-funcs rust

DESCRIPTION="An opinionated code formatter for Lua 5.1, Lua 5.2 and Luau"
HOMEPAGE="https://github.com/JohnnyMorganz/StyLua"
SRC_URI="https://github.com/JohnnyMorganz/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_setup() {
	rust_pkg_setup
}

src_configure() {
	local myfeatures=(${ELUA})
	# lua_foreach_impl myfeatures+="${ELUA}"

	cargo_src_configure --no-default-features
}
