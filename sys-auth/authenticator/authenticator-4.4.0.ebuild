# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4-r1

EAPI=8

MY_P="${P^}"
MY_PN="${PN^}"

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aead@0.5.2
	aes@0.8.3
	aes-gcm@0.10.3
	aho-corasick@1.1.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anyhow@1.0.75
	arrayref@0.3.7
	arrayvec@0.7.4
	async-broadcast@0.5.1
	async-channel@1.9.0
	async-io@1.13.0
	async-io@2.1.0
	async-lock@2.8.0
	async-process@1.8.1
	async-recursion@1.0.5
	async-signal@0.2.5
	async-task@4.5.0
	async-trait@0.1.74
	atomic-waker@1.1.2
	atomic_refcell@0.1.13
	autocfg@1.1.0
	backtrace@0.3.69
	base64@0.21.5
	bitflags@1.3.2
	bitflags@2.4.1
	blake2b_simd@1.0.2
	block@0.1.6
	block-buffer@0.10.4
	block-padding@0.3.3
	blocking@1.4.1
	bumpalo@3.14.0
	bytecount@0.6.7
	bytemuck@1.14.0
	byteorder@1.5.0
	bytes@1.5.0
	cairo-rs@0.18.3
	cairo-sys-rs@0.18.2
	camino@1.1.6
	cargo-platform@0.1.4
	cargo_metadata@0.14.2
	cbc@0.1.2
	cc@1.0.83
	cfg-expr@0.15.5
	cfg-if@1.0.0
	checked_int_cast@1.0.0
	chrono@0.4.31
	cipher@0.4.4
	color_quant@1.1.0
	concurrent-queue@2.3.0
	constant_time_eq@0.3.0
	core-foundation@0.9.3
	core-foundation-sys@0.8.4
	cpufeatures@0.2.11
	crc32fast@1.3.2
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	ctr@0.9.2
	data-encoding@2.4.0
	deranged@0.3.9
	derivative@2.2.0
	diesel@2.1.3
	diesel_derives@2.1.2
	diesel_migrations@2.1.0
	diesel_table_macro_syntax@0.1.0
	digest@0.10.7
	doc-comment@0.3.3
	either@1.9.0
	encoding_rs@0.8.33
	enum-ordinalize@3.1.15
	enumflags2@0.7.8
	enumflags2_derive@0.7.8
	equivalent@1.0.1
	errno@0.3.5
	error-chain@0.12.4
	event-listener@2.5.3
	event-listener@3.0.1
	fastrand@1.9.0
	fastrand@2.0.1
	fdeflate@0.3.1
	field-offset@0.3.6
	flate2@1.0.28
	fnv@1.0.7
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	form_urlencoded@1.2.0
	futures-channel@0.3.29
	futures-core@0.3.29
	futures-executor@0.3.29
	futures-io@0.3.29
	futures-lite@1.13.0
	futures-macro@0.3.29
	futures-sink@0.3.29
	futures-task@0.3.29
	futures-util@0.3.29
	gdk-pixbuf@0.18.3
	gdk-pixbuf-sys@0.18.0
	gdk4@0.7.3
	gdk4-sys@0.7.2
	gdk4-wayland@0.7.2
	gdk4-wayland-sys@0.7.2
	gdk4-win32@0.7.2
	gdk4-win32-sys@0.7.2
	gdk4-x11@0.7.2
	gdk4-x11-sys@0.7.2
	generic-array@0.14.7
	getrandom@0.2.10
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	ghash@0.5.0
	gimli@0.28.0
	gio@0.18.3
	gio-sys@0.18.1
	glib@0.18.3
	glib-macros@0.18.3
	glib-sys@0.18.1
	glob@0.3.1
	gobject-sys@0.18.0
	graphene-rs@0.18.1
	graphene-sys@0.18.1
	gsk4@0.7.3
	gsk4-sys@0.7.3
	gst-plugin-gtk4@0.11.1
	gst-plugin-version-helper@0.8.0
	gstreamer@0.21.1
	gstreamer-audio@0.21.1
	gstreamer-audio-sys@0.21.1
	gstreamer-base@0.21.0
	gstreamer-base-sys@0.21.1
	gstreamer-gl@0.21.1
	gstreamer-gl-egl@0.21.1
	gstreamer-gl-egl-sys@0.21.1
	gstreamer-gl-sys@0.21.1
	gstreamer-gl-wayland@0.21.1
	gstreamer-gl-wayland-sys@0.21.1
	gstreamer-gl-x11@0.21.1
	gstreamer-gl-x11-sys@0.21.1
	gstreamer-pbutils@0.21.1
	gstreamer-pbutils-sys@0.21.0
	gstreamer-sys@0.21.1
	gstreamer-video@0.21.1
	gstreamer-video-sys@0.21.1
	gtk4@0.7.3
	gtk4-macros@0.7.2
	gtk4-sys@0.7.3
	h2@0.3.21
	hashbrown@0.12.3
	hashbrown@0.14.2
	heck@0.4.1
	hermit-abi@0.3.3
	hex@0.4.3
	hkdf@0.12.3
	hmac@0.12.1
	http@0.2.9
	http-body@0.4.5
	httparse@1.8.0
	httpdate@1.0.3
	hyper@0.14.27
	hyper-tls@0.5.0
	iana-time-zone@0.1.58
	iana-time-zone-haiku@0.1.2
	idna@0.4.0
	image@0.24.7
	indexmap@1.9.3
	indexmap@2.1.0
	inout@0.1.3
	instant@0.1.12
	io-lifetimes@1.0.11
	ipnet@2.9.0
	itertools@0.11.0
	itoa@1.0.9
	js-sys@0.3.65
	lazy_static@1.4.0
	libadwaita@0.5.3
	libadwaita-sys@0.5.3
	libc@0.2.149
	libm@0.2.8
	libsqlite3-sys@0.26.0
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.10
	locale_config@0.3.0
	lock_api@0.4.11
	log@0.4.20
	malloc_buf@0.0.6
	memchr@2.6.4
	memoffset@0.7.1
	memoffset@0.9.0
	migrations_internals@2.1.0
	migrations_macros@2.1.0
	mime@0.3.17
	miniz_oxide@0.7.1
	mio@0.8.9
	muldiv@1.0.1
	native-tls@0.2.11
	nix@0.26.4
	num@0.4.1
	num-bigint@0.4.4
	num-bigint-dig@0.8.4
	num-complex@0.4.4
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.4.1
	num-traits@0.2.17
	num_cpus@1.16.0
	objc@0.2.7
	objc-foundation@0.1.1
	objc_id@0.1.1
	object@0.32.1
	once_cell@1.18.0
	oo7@0.2.1
	opaque-debug@0.3.0
	openssl@0.10.59
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.95
	option-operations@0.5.0
	ordered-stream@0.2.0
	pango@0.18.3
	pango-sys@0.18.0
	parking@2.2.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	paste@1.0.14
	pbkdf2@0.12.2
	percent-encoding@2.3.0
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	piper@0.2.1
	pkg-config@0.3.27
	png@0.17.10
	polling@2.8.0
	polling@3.3.0
	polyval@0.6.1
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	pretty-hex@0.3.0
	proc-macro-crate@1.3.1
	proc-macro-crate@2.0.0
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.69
	prost@0.12.1
	prost-derive@0.12.1
	pulldown-cmark@0.9.3
	qrencode@0.14.0
	quick-xml@0.30.0
	quote@1.0.33
	r2d2@0.8.10
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.4.1
	regex@1.10.2
	regex-automata@0.4.3
	regex-syntax@0.8.2
	reqwest@0.11.22
	ring@0.17.5
	roxmltree@0.18.1
	rust-argon2@2.0.0
	rustc-demangle@0.1.23
	rustc_version@0.4.0
	rustix@0.37.27
	rustix@0.38.21
	ryu@1.0.15
	salsa20@0.10.2
	same-file@1.0.6
	schannel@0.1.22
	scheduled-thread-pool@0.2.7
	scopeguard@1.2.0
	scrypt@0.11.0
	search-provider@0.6.0
	security-framework@2.9.2
	security-framework-sys@2.9.1
	semver@1.0.20
	serde@1.0.190
	serde_derive@1.0.190
	serde_json@1.0.108
	serde_repr@0.1.17
	serde_spanned@0.6.4
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.8
	sharded-slab@0.1.7
	signal-hook-registry@1.4.1
	simd-adler32@0.3.7
	skeptic@0.13.7
	slab@0.4.9
	smallvec@1.11.1
	socket2@0.4.10
	socket2@0.5.5
	spin@0.5.2
	spin@0.9.8
	static_assertions@1.1.0
	subtle@2.5.0
	svg_metadata@0.4.4
	syn@1.0.109
	syn@2.0.38
	system-configuration@0.5.1
	system-configuration-sys@0.5.0
	system-deps@6.2.0
	target-lexicon@0.12.12
	temp-dir@0.1.11
	tempfile@3.8.1
	thiserror@1.0.50
	thiserror-impl@1.0.50
	thread_local@1.1.7
	time@0.3.30
	time-core@0.1.2
	time-macros@0.2.15
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio@1.33.0
	tokio-macros@2.1.0
	tokio-native-tls@0.3.1
	tokio-util@0.7.10
	toml@0.7.8
	toml@0.8.6
	toml_datetime@0.6.5
	toml_edit@0.19.15
	toml_edit@0.20.7
	tower-service@0.3.2
	tracing@0.1.40
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-subscriber@0.3.17
	try-lock@0.2.4
	typenum@1.17.0
	uds_windows@1.0.2
	unicase@2.7.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	universal-hash@0.5.1
	untrusted@0.9.0
	url@2.4.1
	uuid@1.5.0
	vcpkg@0.2.15
	version-compare@0.1.1
	version_check@0.9.4
	waker-fn@1.1.1
	walkdir@2.4.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.88
	wasm-bindgen-backend@0.2.88
	wasm-bindgen-futures@0.4.38
	wasm-bindgen-macro@0.2.88
	wasm-bindgen-macro-support@0.2.88
	wasm-bindgen-shared@0.2.88
	web-sys@0.3.65
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-core@0.51.1
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	winnow@0.5.19
	winreg@0.50.0
	xdg-home@1.0.0
	xmlparser@0.13.6
	zbar-rust@0.0.21
	zbus@3.14.1
	zbus_macros@3.14.1
	zbus_names@2.6.0
	zeroize@1.6.0
	zeroize_derive@1.4.2
	zvariant@3.15.0
	zvariant_derive@3.15.0
	zvariant_utils@1.0.1
"

inherit meson gnome2-utils cargo

DESCRIPTION="Generate Two-Factor Codes"
HOMEPAGE="https://gitlab.gnome.org/World/Authenticator"
SRC_URI="https://gitlab.gnome.org/World/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://crates.io/api/v1/crates/aperture/0.3.2/download -> aperture-0.3.2.crate.tar.gz"
SRC_URI+=" https://crates.io/api/v1/crates/ashpd/0.6.7/download -> ashpd-0.6.7.crate.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="wayland x11"

REQUIRED_USE="|| ( wayland x11 )"

DEPEND="media-gfx/zbar
>=x11-libs/pango-1.51.0"
RDEPEND="${DEPEND}"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${MY_PN}"

PATCHES=(
	"${FILESDIR}/authenticator-x11-wayland-feature.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	pushd "${WORKDIR}/aperture-0.3.2" || die
	eapply "${FILESDIR}/aperture-x11-wayland-feature.patch"
	popd || die

	pushd "${WORKDIR}/ashpd-0.6.7" || die
	eapply "${FILESDIR}/ashpd-x11-wayland-feature.patch"
	popd || die
}

src_configure() {
	local emesonargs=(
		-Dprofile=default
	)

	if use x11 && use wayland; then
		emesonargs+=(-Ddisplay_backend=wayland,x11)
	elif use x11; then
		emesonargs+=(-Ddisplay_backend=x11)
	elif use wayland; then
		emesonargs+=(-Ddisplay_backend=wayland)
	fi

	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	update_desktop_database
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
