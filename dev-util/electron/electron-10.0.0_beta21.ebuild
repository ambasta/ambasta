# Copyright 2009-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit check-reqs chromium-2 flag-o-matic multilib ninja-utils pax-utils portability python-any-r1 toolchain-funcs

CHROMIUM_VERSION="85.0.4183.59"
CHROMIUM_P="chromium-${CHROMIUM_VERSION}"
NODE_VERSION="12.14.1"
MY_P="${PN}-10.0.0-beta.21"

DESCRIPTION="Cross platform application development framework based on web technologies"
HOMEPAGE="https://electronjs.org/"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${CHROMIUM_P}.tar.xz
	https://github.com/electron/electron/archive/v10.0.0-beta.21.tar.gz -> ${P}.tar.gz

	https://registry.yarnpkg.com/@electron/docs-parser/-/docs-parser-0.7.2.tgz -> @electron-docs-parser-0.7.2.tgz
	https://registry.yarnpkg.com/@electron/typescript-definitions/-/typescript-definitions-8.7.2.tgz -> @electron-typescript-definitions-8.7.2.tgz
	https://registry.yarnpkg.com/@octokit/rest/-/rest-16.3.2.tgz -> @octokit-rest-16.3.2.tgz
	https://registry.yarnpkg.com/@primer/octicons/-/octicons-9.1.1.tgz -> @primer-octicons-9.1.1.tgz
	https://registry.yarnpkg.com/@types/basic-auth/-/basic-auth-1.1.3.tgz -> @types-basic-auth-1.1.3.tgz
	https://registry.yarnpkg.com/@types/busboy/-/busboy-0.2.3.tgz -> @types-busboy-0.2.3.tgz
	https://registry.yarnpkg.com/@types/chai/-/chai-4.2.11.tgz -> @types-chai-4.2.11.tgz
	https://registry.yarnpkg.com/@types/chai-as-promised/-/chai-as-promised-7.1.2.tgz -> @types-chai-as-promised-7.1.2.tgz
	https://registry.yarnpkg.com/@types/dirty-chai/-/dirty-chai-2.0.2.tgz -> @types-dirty-chai-2.0.2.tgz
	https://registry.yarnpkg.com/@types/express/-/express-4.17.3.tgz -> @types-express-4.17.3.tgz
	https://registry.yarnpkg.com/@types/fs-extra/-/fs-extra-8.1.0.tgz -> @types-fs-extra-8.1.0.tgz
	https://registry.yarnpkg.com/@types/mocha/-/mocha-7.0.2.tgz -> @types-mocha-7.0.2.tgz
	https://registry.yarnpkg.com/@types/node/-/node-12.12.6.tgz -> @types-node-12.12.6.tgz
	https://registry.yarnpkg.com/@types/semver/-/semver-7.1.0.tgz -> @types-semver-7.1.0.tgz
	https://registry.yarnpkg.com/@types/send/-/send-0.14.5.tgz -> @types-send-0.14.5.tgz
	https://registry.yarnpkg.com/@types/split/-/split-1.0.0.tgz -> @types-split-1.0.0.tgz
	https://registry.yarnpkg.com/@types/uuid/-/uuid-3.4.6.tgz -> @types-uuid-3.4.6.tgz
	https://registry.yarnpkg.com/@types/webpack/-/webpack-4.41.7.tgz -> @types-webpack-4.41.7.tgz
	https://registry.yarnpkg.com/@types/webpack-env/-/webpack-env-1.15.1.tgz -> @types-webpack-env-1.15.1.tgz
	https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-2.24.0.tgz -> @typescript-eslint-eslint-plugin-2.24.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-2.24.0.tgz -> @typescript-eslint-parser-2.24.0.tgz
	https://registry.yarnpkg.com/asar/-/asar-3.0.1.tgz
	https://registry.yarnpkg.com/check-for-leaks/-/check-for-leaks-1.2.1.tgz
	https://registry.yarnpkg.com/colors/-/colors-1.1.2.tgz
	https://registry.yarnpkg.com/dotenv-safe/-/dotenv-safe-4.0.4.tgz
	https://registry.yarnpkg.com/dugite/-/dugite-1.45.0.tgz
	https://registry.yarnpkg.com/eslint/-/eslint-5.13.0.tgz
	https://registry.yarnpkg.com/eslint-config-standard/-/eslint-config-standard-12.0.0.tgz
	https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.17.2.tgz
	https://registry.yarnpkg.com/eslint-plugin-mocha/-/eslint-plugin-mocha-5.2.0.tgz
	https://registry.yarnpkg.com/eslint-plugin-node/-/eslint-plugin-node-8.0.1.tgz
	https://registry.yarnpkg.com/eslint-plugin-standard/-/eslint-plugin-standard-4.0.0.tgz
	https://registry.yarnpkg.com/eslint-plugin-typescript/-/eslint-plugin-typescript-0.14.0.tgz
	https://registry.yarnpkg.com/express/-/express-4.16.4.tgz
	https://registry.yarnpkg.com/folder-hash/-/folder-hash-2.1.1.tgz
	https://registry.yarnpkg.com/fs-extra/-/fs-extra-7.0.1.tgz
	https://registry.yarnpkg.com/husky/-/husky-2.2.0.tgz
	https://registry.yarnpkg.com/klaw/-/klaw-3.0.0.tgz
	https://registry.yarnpkg.com/lint/-/lint-1.1.2.tgz
	https://registry.yarnpkg.com/lint-staged/-/lint-staged-8.1.0.tgz
	https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz
	https://registry.yarnpkg.com/nugget/-/nugget-2.0.1.tgz
	https://registry.yarnpkg.com/null-loader/-/null-loader-4.0.0.tgz
	https://registry.yarnpkg.com/pre-flight/-/pre-flight-1.1.0.tgz
	https://registry.yarnpkg.com/remark-cli/-/remark-cli-4.0.0.tgz
	https://registry.yarnpkg.com/remark-preset-lint-markdown-style-guide/-/remark-preset-lint-markdown-style-guide-2.1.1.tgz
	https://registry.yarnpkg.com/request/-/request-2.88.0.tgz
	https://registry.yarnpkg.com/semver/-/semver-5.6.0.tgz
	https://registry.yarnpkg.com/shx/-/shx-0.3.2.tgz
	https://registry.yarnpkg.com/standard-markdown/-/standard-markdown-5.0.0.tgz
	https://registry.yarnpkg.com/sumchecker/-/sumchecker-2.0.2.tgz
	https://registry.yarnpkg.com/tap-xunit/-/tap-xunit-2.4.1.tgz
	https://registry.yarnpkg.com/temp/-/temp-0.8.3.tgz
	https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-1.4.2.tgz
	https://registry.yarnpkg.com/ts-loader/-/ts-loader-6.0.2.tgz
	https://registry.yarnpkg.com/ts-node/-/ts-node-6.0.3.tgz
	https://registry.yarnpkg.com/typescript/-/typescript-3.8.3.tgz
	https://registry.yarnpkg.com/webpack/-/webpack-4.42.0.tgz
	https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-3.3.11.tgz
"

#UGC_PV="${PV/_p/-}"
#UGC_P="${PN}-${UGC_PV}"
#UGC_URL="https://github.com/Eloston/${PN}/archive/"
#UGC_COMMIT_ID="058925cdb9b8391c0bfab250ac031cb9aaf3c614"

#if [ -z "$UGC_COMMIT_ID" ]
#then
#	UGC_URL="${UGC_URL}${UGC_PV}.tar.gz -> ${UGC_P}.tar.gz"
#	UGC_WD="${WORKDIR}/${UGC_P}"
#else
#	UGC_URL="${UGC_URL}${UGC_COMMIT_ID}.tar.gz -> ${PN}-${UGC_COMMIT_ID}.tar.gz"
#	UGC_WD="${WORKDIR}/ungoogled-chromium-${UGC_COMMIT_ID}"
#fi

#DESCRIPTION="Modifications to Chromium for removing Google integration and enhancing privacy"
#HOMEPAGE="https://www.chromium.org/Home https://github.com/Eloston/ungoogled-chromium"
#SRC_URI="
#	https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV/_*}.tar.xz
#	https://files.pythonhosted.org/packages/ed/7b/bbf89ca71e722b7f9464ebffe4b5ee20a9e5c9a555a56e2d3914bb9119a6/setuptools-44.1.0.zip
#	${UGC_URL}
#"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="amd64 ~x86"
IUSE="+clang closure-compile cups custom-cflags enable-driver gnome hangouts kerberos optimize-thinlto optimize-webui +proprietary-codecs pulseaudio selinux +system-ffmpeg +system-harfbuzz +system-icu +system-jsoncpp +system-libevent +system-libvpx +system-openh264 system-openjpeg +tcmalloc thinlto vaapi vdpau"
RESTRICT="
	!system-ffmpeg? ( proprietary-codecs? ( bindist ) )
	!system-openh264? ( bindist )
"
REQUIRED_USE="
	thinlto? ( clang )
	optimize-thinlto? ( thinlto )
	x86? ( !thinlto )
"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.26:2
	app-arch/bzip2:=
	cups? ( >=net-print/cups-1.3.11:= )
	>=dev-libs/atk-2.26
	dev-libs/expat:=
	dev-libs/glib:2
	system-icu? ( >=dev-libs/icu-67.1:= )
	>=dev-libs/libxml2-2.9.4-r3:=[icu]
	dev-libs/libxslt:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	>=dev-libs/re2-0.2019.08.01:=
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	system-harfbuzz? (
		media-libs/freetype:=
		>=media-libs/harfbuzz-2.4.0:0=[icu(-)]
	)
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/mesa:=[gbm]
	system-libvpx? (
		media-libs/libvpx:=[postproc,svc]
		|| (
			=media-libs/libvpx-1.7*
			>media-libs/libvpx-1.8.1
		)
	)
	>=media-libs/openh264-1.6.0:=
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? (
		>=media-video/ffmpeg-4:=
		|| (
			media-video/ffmpeg[-samba]
			>=net-fs/samba-4.5.10-r1[-debug(-)]
		)
		>=media-libs/opus-1.3.1:=
	)
	sys-apps/dbus:=
	sys-apps/pciutils:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	x11-libs/pango:=
	app-arch/snappy:=
	media-libs/flac:=
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	kerberos? ( virtual/krb5 )
	media-libs/lcms:=
	system-jsoncpp? ( dev-libs/jsoncpp )
	system-libevent? ( dev-libs/libevent )
	system-openjpeg? ( media-libs/openjpeg:2= )
	vaapi? ( x11-libs/libva:= )
"
# For nvidia-drivers blocker, see bug #413637 .
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )
	!www-client/chromium
	!www-client/chromium-bin
	!www-client/ungoogled-chromium-bin
"
DEPEND="${COMMON_DEPEND}
"
# dev-vcs/git - https://bugs.gentoo.org/593476
BDEPEND="
	${PYTHON_DEPS}
	>=app-arch/gzip-1.7
	app-arch/unzip
	dev-lang/perl
	>=dev-util/gn-0.1726
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-7.6.0[inspector]
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	closure-compile? ( virtual/jre )
	!system-libvpx? (
		amd64? ( dev-lang/yasm )
		x86? ( dev-lang/yasm )
	)
	clang? ( sys-devel/clang )
	thinlto? ( sys-devel/lld )
	sys-apps/yarn
"

S="${WORKDIR}/${CHROMIUM_P}"
PATCHES=(
	"${FILESDIR}/chromium-84-mediaalloc.patch"
)

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge 8.0; then
			die "At least gcc 8.0 is required"
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="7G"
	if ( shopt -s extglob; is-flagq '-g?(gdb)?([1-9])' ); then
		CHECKREQS_DISK_BUILD="25G"
	fi
	check-reqs_pkg_setup
}

pkg_pretend() {
	if use custom-cflags && [[ "${MERGE_TYPE}" != binary ]]; then
		ewarn
		ewarn "USE=custom-cflags bypasses strip-flags"
		ewarn "Consider disabling this USE flag if something breaks"
		ewarn
	fi

	pre_build_checks
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	unpack ${CHROMIUM_P}.tar.xz
	unpack "${P}".tar.gz

	einfo "Disabling dugite"
	sed -i '/dugite/d' "${WORKDIR}/${MY_P}/package.json" || die

	popd > /dev/null || die
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	default

	ln -s "${WORKDIR}/${MY_P}" electron || die

	if use vaapi
	then
		elog "Even though ${PN} is built with vaapi support, #ignore-gpu-blacklist"
		elog "should be enabled via flags or commandline for it to work."
	fi

	declare -A patches=(
		["electron/patches/chromium"]="."
		["electron/patches/boringssl"]="third_party/boringssl/src"
		["electron/patches/v8"]="v8"
	)
	for patch_folder in "${!patches[@]}";
	do
		readarray -t topatch < "${patch_folder}/.patches"
		einfo "Applying patches from ${patch_folder}"
		for i in "${topatch[@]}";
		do
			if [ "$i" = "fix_remove_unused_llhttp_variables.patch" ]; then continue; fi
			pushd "${patches[$patch_folder]}" > /dev/null || die
			eapply "${S}/${patch_folder}/$i" || die
			popd > /dev/null || die
		done
	done

	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/dynamic_annotations
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/valgrind
		base/third_party/xdg_mime
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		chrome/third_party/mozilla_security_manager
		courgette/third_party
		net/third_party/mozilla_security_manager
		net/third_party/nss
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/base
		third_party/angle/src/common/third_party/smhasher
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/compiler
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/trace_event
		third_party/angle/src/third_party/volk
		third_party/angle/third_party/glslang
		third_party/angle/third_party/spirv-headers
		third_party/angle/third_party/spirv-tools
		third_party/angle/third_party/vulkan-headers
		third_party/angle/third_party/vulkan-loader
		third_party/angle/third_party/vulkan-tools
		third_party/angle/third_party/vulkan-validation-layers
		third_party/apple_apsl
		third_party/axe-core
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/cacheinvalidation
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4
		third_party/catapult/third_party/html5lib-python
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/dav1d
		third_party/dawn
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/fabricjs
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/third_party
		third_party/dom_distiller_js
		third_party/emoji-segmenter
		third_party/flatbuffers
	)
	use system-harfbuzz || keeplibs+=(
		third_party/freetype
		third_party/harfbuzz-ng
	)
	keeplibs+=(
		third_party/libgifcodec
		third_party/glslang
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/harfbuzz-ng/utils
		third_party/hunspell
		third_party/iccjpeg
		third_party/inspector_protocol
		third_party/jinja2
	)
	use system-jsoncpp || keeplibs+=(
		third_party/jsoncpp
	)
	keeplibs+=(
		third_party/jstemplate
		third_party/khronos
		third_party/leveldatabase
		third_party/libXNVCtrl
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libudev
		third_party/libwebm
		third_party/libxml/chromium
		third_party/libyuv
		third_party/llvm
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/mesa
		third_party/metrics_proto
		third_party/modp_b64
		third_party/nasm
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/base
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
	)
	use system-openjpeg || keeplibs+=(
		third_party/pdfium/third_party/libopenjpeg20
	)
	keeplibs+=(
		third_party/pdfium/third_party/libpng16
		third_party/pdfium/third_party/libtiff
		third_party/pdfium/third_party/skia_shared
		third_party/perfetto
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private-join-and-compute
		third_party/protobuf
		third_party/protobuf/third_party/six
		third_party/pyjson5
		third_party/qcms
		third_party/rnnoise
		third_party/s2cellid
		third_party/schema_org
		third_party/simplejson
		third_party/skia
		third_party/skia/include/third_party/skcms
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/skcms
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/spirv-headers
		third_party/SPIRV-Tools
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-7.0
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/subzero
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv/unified1
		third_party/usrsctp
		third_party/vulkan
		third_party/wayland
		third_party/web-animations-js
		third_party/webdriver
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/fft4g
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/base64
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/wuffs
		third_party/zlib/google
		tools/grit/third_party/six
		url/third_party/mozilla
		v8/src/third_party/siphash
		v8/src/third_party/valgrind
		v8/src/third_party/utf8-decoder
		v8/third_party/inspector_protocol
		v8/third_party/v8
	)
	use system-libevent || keeplibs+=(
		base/third_party/libevent
	)
	keeplibs+=(
		third_party/adobe
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
		third_party/yasm/run_yasm.py
	)
	if ! use system-ffmpeg; then
		keeplibs+=( third_party/ffmpeg third_party/opus )
	fi
	if ! use system-icu; then
		keeplibs+=( third_party/icu )
	fi
	if ! use system-libvpx; then
		keeplibs+=( third_party/libvpx )
		keeplibs+=( third_party/libvpx/source/libvpx/third_party/x86inc )
	fi
	if use tcmalloc; then
		keeplibs+=( third_party/tcmalloc )
	fi
	if ! use system-openh264; then
		keeplibs+=( third_party/openh264 )
	fi
	ebegin "Removing unneeded bundled libraries"

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove

	eend $? || die
}

src_configure() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	ebegin "Installing node_modules"
	pushd electron > /dev/null || die
	yarn config set yarn-offline-mirror "${DISTDIR}" || die
	yarn config set disable-self-update-check true || die
	yarn install --frozen-lockfile --offline --no-progress || die
	popd > /dev/null || die
	eend $? || die

	local myconf_gn="use_ozone=true ozone_auto_platforms=false ozone_platform_headless=true use_system_libdrm=true ozone_platform_wayland=true ozone_platform_x11=true use_system_minigbm=true use_xkbcommon=true ozone_platform=\"wayland\""

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	if use clang && ! tc-is-clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		AR=llvm-ar #thinlto fails otherwise
		strip-unsupported-flags
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		AR=gcc-ar #just in case
		strip-unsupported-flags
	fi

	if tc-is-clang; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		myconf_gn+=" is_clang=false"
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	myconf_gn+=" use_allocator=$(usex tcmalloc \"tcmalloc\" \"none\")"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	local gn_system_libraries=(
		flac
		fontconfig
		freetype
		libdrm
		libjpeg
		libpng
		libwebp
		libxml
		libxslt
	)
	use system-openh264 && gn_system_libraries+=(
		openh264
	)
	gn_system_libraries+=(
		re2
		snappy
		yasm
		zlib
	)
	if use system-ffmpeg; then
		gn_system_libraries+=( ffmpeg opus )
	fi
	if use system-icu; then
		gn_system_libraries+=( icu )
	fi
	if use system-libvpx; then
		gn_system_libraries+=( libvpx )
	fi
	if use system-harfbuzz; then
		gn_system_libraries+=( freetype harfbuzz-ng )
	fi
	if use system-libevent; then
		gn_system_libraries+=( libevent )
	fi
	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=true"

	# Disable deprecated libgnome-keyring dependency, bug #713012
	myconf_gn+=" use_gnome_keyring=false"

	# Optional dependencies.
	myconf_gn+=" closure_compile=$(usex closure-compile true false)"
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
	myconf_gn+=" link_pulseaudio=$(usex pulseaudio true false)"

	myconf_gn+=" use_thin_lto=$(usex thinlto true false)"
	myconf_gn+=" thin_lto_enable_optimizations=$(usex optimize-thinlto true false)"

	myconf_gn+=" optimize_webui=$(usex optimize-webui true false)"
	myconf_gn+=" use_gio=$(usex gnome true false)"
	myconf_gn+=" use_openh264=$(usex system-openh264 false true)"
	myconf_gn+=" use_system_freetype=$(usex system-harfbuzz true false)"
	myconf_gn+=" use_system_libopenjpeg2=$(usex system-openjpeg true false)"
	myconf_gn+=" use_vaapi=$(usex vaapi true false)"
	myconf_gn+=" enable_pdf=true"
	myconf_gn+=" use_system_lcms2=true"
	myconf_gn+=" enable_print_preview=true"

	# Ungoogled flags
	myconf_gn+=" enable_mdns=false"
	myconf_gn+=" enable_mse_mpeg2ts_stream_parser=true"
	myconf_gn+=" enable_nacl_nonsfi=false"
	myconf_gn+=" enable_one_click_signin=false"
	myconf_gn+=" enable_reading_list=false"
	myconf_gn+=" enable_remoting=false"
	#myconf_gn+=" enable_reporting=false"
	myconf_gn+=" enable_service_discovery=false"
	myconf_gn+=" exclude_unwind_tables=true"
	myconf_gn+=" use_official_google_api_keys=false"
	myconf_gn+=" google_api_key=\"\""
	myconf_gn+=" google_default_client_id=\"\""
	myconf_gn+=" google_default_client_secret=\"\""
	myconf_gn+=" safe_browsing_mode=0"
	myconf_gn+=" use_unofficial_version_number=false"
	myconf_gn+=" blink_symbol_level=0"
	myconf_gn+=" symbol_level=0"
	myconf_gn+=" enable_iterator_debugging=false"
	myconf_gn+=" enable_swiftshader=false"
	myconf_gn+=" is_official_build=true"

	# Additional flags
	myconf_gn+=" use_system_libjpeg=true"
	myconf_gn+=" use_system_zlib=true"
	myconf_gn+=" rtc_build_examples=false"

	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false linux_use_bundled_binutils=false use_custom_libcxx=false"

	# Disable forced lld, bug 641556
	myconf_gn+=" use_lld=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""

	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		filter-flags "-O*" "-Wl,-O*"; #See #25
		strip-flags

		# Prevent linker from running out of address space, bug #471810 .
		if use x86; then
			filter-flags "-g*"
		fi

		# Prevent libvpx build failures. Bug 530248, 544702, 546984.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]]; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2
		fi
	fi

	local dest_cpu=""

	if [[ $myarch = amd64 ]] ; then
		dest_cpu=x64
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
		dest_cpu="x64"
	elif [[ $myarch = x86 ]] ; then
		myconf_gn+=" target_cpu=\"x86\""
		ffmpeg_target_arch=ia32
		dest_cpu="x86"

		# This is normally defined by compiler_cpu_abi in
		# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
		dest_cpu="arm64"
	elif [[ $myarch = arm ]] ; then
		myconf_gn+=" target_cpu=\"arm\""
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
		dest_cpu="arm"
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	if use thinlto; then
		# We need to change the default value of import-instr-limit in
		# LLVM to limit the text size increase. The default value is
		# 100, and we change it to 30 to reduce the text size increase
		# from 25% to 10%. The performance number of page_cycler is the
		# same on two of the thinLTO configurations, we got 1% slowdown
		# on speedometer when changing import-instr-limit from 100 to 30.
		append-ldflags "-Wl,-plugin-opt,-import-instr-limit=30"

		append-ldflags "-Wl,--thinlto-jobs=$(makeopts_jobs)"
		myconf_gn+=" use_lld=true"
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	#if ! use system-ffmpeg; then
	if false; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]]; then
			build_ffmpeg_args+=" --disable-asm"
		fi

		# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
		einfo "Configuring bundled ffmpeg..."
		pushd third_party/ffmpeg > /dev/null || die
		chromium/scripts/build_ffmpeg.py linux ${ffmpeg_target_arch} \
			--branding ${ffmpeg_branding} -- ${build_ffmpeg_args} || die
		chromium/scripts/copy_config.sh || die
		chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	# Chromium relies on this, but was disabled in >=clang-10, crbug.com/1042470
	append-cxxflags $(test-flags-CXX -flax-vector-conversions=all)

	# Explicitly disable ICU data file support for system-icu builds.
	if use system-icu; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	if tc-is-clang; then
		# Don't complain if Chromium uses a diagnostic option that is not yet
		# implemented in the compiler version used by the user. This is only
		# supported by Clang.
		append-flags -Wno-unknown-warning-option
	fi

	# Facilitate deterministic builds (taken from build/config/compiler/BUILD.gn)
	append-cflags -Wno-builtin-macro-redefined
	append-cxxflags -Wno-builtin-macro-redefined
	append-cppflags "-D__DATE__= -D__TIME__= -D__TIMESTAMP__="

	myconf_gn+=" import(\"//electron/build/args/release.gn\")"

	local flags
	einfo "Building with following compiler settings:"
	for flags in C{C,XX} AR NM RANLIB {C,CXX,CPP,LD}FLAGS; do
		einfo "  ${flags} = \"${!flags}\""
	done

	./configure --shared \
		--without-dtrace \
		--without-npm \
		--without-bundled-v8 \
		--shared-http-parser \
		--shared-nghttp2 \
		--shared-openssl \
		--shared-zlib \
		--shared-cares \
		--shared-libuv \
		--with-intl=system-icu \
		--dest-cpu=${dest_cpu} || die
	popd > /dev/null || die

	einfo "Configuring Electron..."
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

src_compile() {
	# Final link uses lots of file descriptors.
	ulimit -n 4096

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Build mksnapshot and pax-mark it.
	local x
	for x in mksnapshot v8_context_snapshot_generator; do
		if tc-is-cross-compiler; then
			eninja -C out/Release "host/${x}"
			pax-mark m "out/Release/host/${x}"
		else
			eninja -C out/Release "${x}"
			pax-mark m "out/Release/${x}"
		fi
	done

	# Work around broken deps
	eninja -C out/Release gen/ui/accessibility/ax_enums.mojom{,-shared}.h

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release electron

	use enable-driver && eninja -C out/Release chromedriver

	pax-mark m out/Release/electron
}

src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/electron-${PV}"
	exeinto "${CHROMIUM_HOME}"

	doexe out/Release/electron
	dosym "${CHROMIUM_HOME}/electron" "/usr/bin/electron-${PV}"

	use enable-driver && doexe out/Release/chromedriver

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak
	doins out/Release/*.so

	if ! use system-icu; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/resources

	#if [[ -d out/Release/swiftshader ]]; then
	#	insinto "${CHROMIUM_HOME}/swiftshader"
	#	doins out/Release/swiftshader/*.so
	#fi

	fperms -R 755 "${CHROMIUM_HOME}/npm/bin/"

	insinto "/usr/include/electron-${PV}/"
}

pkg_postinst() {
	electron-config update
}

pkg_postrm() {
	electron-config update
}
