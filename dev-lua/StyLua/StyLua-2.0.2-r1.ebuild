# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(lua5-{1..2})

CRATES="
aho-corasick-1.1.2
anes-0.1.6
anstyle-1.0.4
anyhow-1.0.79
assert_cmd-2.0.13
assert_fs-1.1.1
atty-0.2.14
autocfg-1.1.0
bitflags-1.3.2
bitflags-2.4.2
borsh-1.5.1
bstr-1.9.0
bumpalo-3.14.0
bytecount-0.6.7
cast-0.3.0
cfg-if-1.0.0
cfg_aliases-0.2.1
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clap-3.2.25
clap_derive-3.2.25
clap_lex-0.2.4
console-0.15.8
criterion-0.4.0
criterion-plot-0.5.0
crossbeam-channel-0.5.11
crossbeam-deque-0.8.5
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.19
crunchy-0.2.2
derive_more-1.0.0
derive_more-impl-1.0.0
difflib-0.4.0
doc-comment-0.3.3
ec4rs-1.0.2
either-1.9.0
encode_unicode-0.3.6
env_logger-0.10.2
equivalent-1.0.1
errno-0.3.8
fastrand-2.0.1
full_moon-1.1.2
full_moon_derive-0.11.0
globset-0.4.14
globwalk-0.9.1
half-2.3.1
hashbrown-0.12.3
hashbrown-0.14.3
heck-0.4.1
hermit-abi-0.1.19
hermit-abi-0.3.4
ignore-0.4.22
indexmap-1.9.3
indexmap-2.1.0
insta-1.34.0
itertools-0.10.5
itoa-1.0.10
js-sys-0.3.67
lazy_static-1.4.0
libc-0.2.155
linked-hash-map-0.5.6
linux-raw-sys-0.4.13
log-0.4.20
memchr-2.7.1
num-traits-0.2.17
num_cpus-1.16.0
once_cell-1.19.0
oorandom-11.1.3
os_str_bytes-6.6.1
paste-1.0.14
plotters-0.3.5
plotters-backend-0.3.5
plotters-svg-0.3.5
predicates-3.1.0
predicates-core-1.0.6
predicates-tree-1.0.9
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.78
quote-1.0.35
rayon-1.8.1
rayon-core-1.12.1
redox_syscall-0.4.1
regex-1.10.3
regex-automata-0.4.5
regex-syntax-0.8.2
rustix-0.38.30
rustversion-1.0.14
ryu-1.0.16
same-file-1.0.6
serde-1.0.196
serde_derive-1.0.196
serde_json-1.0.112
serde_spanned-0.6.5
similar-2.4.0
smol_str-0.3.2
strsim-0.10.0
strum-0.25.0
strum_macros-0.25.3
stylua-2.0.2
syn-1.0.109
syn-2.0.48
tempfile-3.9.0
termcolor-1.4.1
termtree-0.4.1
textwrap-0.16.0
thiserror-1.0.56
thiserror-impl-1.0.56
threadpool-1.8.1
tinytemplate-1.2.1
toml-0.8.8
toml_datetime-0.6.5
toml_edit-0.21.0
unicode-ident-1.0.12
unicode-width-0.1.11
unicode-xid-0.2.6
version_check-0.9.4
wait-timeout-0.2.0
walkdir-2.4.0
wasm-bindgen-0.2.90
wasm-bindgen-backend-0.2.90
wasm-bindgen-macro-0.2.90
wasm-bindgen-macro-support-0.2.90
wasm-bindgen-shared-0.2.90
web-sys-0.3.67
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.6
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.52.0
windows-targets-0.52.0
windows_aarch64_gnullvm-0.52.0
windows_aarch64_msvc-0.52.0
windows_i686_gnu-0.52.0
windows_i686_msvc-0.52.0
windows_x86_64_gnu-0.52.0
windows_x86_64_gnullvm-0.52.0
windows_x86_64_msvc-0.52.0
winnow-0.5.35
yaml-rust-0.4.5
"

RUST_MAX_VER="1.87.0"
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
