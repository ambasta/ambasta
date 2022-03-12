# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

LLVM_MAX_SLOT=13

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="ncurses,sqlite,ssl"

WANT_AUTOCONF="2.1"

MOZ_PV=${PV}
MOZ_PV_SUFFIX=

MOZ_PN="${PN%-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"
MOZ_PV_DISTFILES="${MOZ_PV}${MOZ_PV_SUFFIX}"
MOZ_P_DISTFILES="${MOZ_PN}-${MOZ_PV_DISTFILES}"

inherit autotools check-reqs desktop flag-o-matic gnome2-utils linux-info \
	llvm multiprocessing pax-utils python-any-r1 toolchain-funcs \
	virtualwl xdg

MOZ_SRC_BASE_URI="https://archive.mozilla.org/pub/${MOZ_PN}/releases/${MOZ_PV}"

SRC_URI="${MOZ_SRC_BASE_URI}/source/${MOZ_P}.source.tar.xz -> ${MOZ_P_DISTFILES}.source.tar.xz"

PATCHES=(
	"${FILESDIR}/0001-Don-t-use-build-id.patch"
	"${FILESDIR}/0002-Fortify-sources-properly.patch"
	"${FILESDIR}/0003-Check-additional-plugins-dir.patch"
	"${FILESDIR}/0004-PATCH-04-30-bmo-847568-Support-system-harfbuzz.patch"
	"${FILESDIR}/0005-PATCH-05-30-bmo-847568-Support-system-graphite2.patch"
	"${FILESDIR}/0007-PATCH-05-30-Support-sndio-audio-framework.patch"
	"${FILESDIR}/0008-bmo-878089-Don-t-fail-when-TERM-is-not-set.patch"
	"${FILESDIR}/0009-bmo-1516803-Fix-building-sandbox.patch"
	"${FILESDIR}/0010-musl-Add-alternate-name-for-private-siginfo-struct-m.patch"
	"${FILESDIR}/0011-Make-PGO-use-toolchain.patch"
	"${FILESDIR}/0012-bmo-1516081-Disable-watchdog-during-PGO-builds.patch"
	"${FILESDIR}/0013-bmo-1516803-force-one-LTO-partition-for-sandbox-when.patch"
	"${FILESDIR}/0014-bmo-1196777-Set-GDK_FOCUS_CHANGE_MASK.patch"
	"${FILESDIR}/0015-Fix-building-with-PGO-when-using-GCC.patch"
	"${FILESDIR}/0016-libaom-Use-NEON_FLAGS-instead-of-VPX_ASFLAGS-for-lib.patch"
	"${FILESDIR}/0017-build-Disable-Werror.patch"
	"${FILESDIR}/0019-Disable-FFVPX-with-VA-API.patch"
	"${FILESDIR}/0020-Enable-FLAC-on-platforms-without-ffvpx-via-ffmpeg.patch"
	"${FILESDIR}/0021-bmo-1670333-OpenH264-Fix-decoding-if-it-starts-on-no.patch"
	"${FILESDIR}/0022-bmo-1663844-OpenH264-Allow-using-OpenH264-GMP-decode.patch"
	"${FILESDIR}/0023-PATCH-30-30-bgo-816975-Fix-build-on-x86.patch"
	"${FILESDIR}/0024-PATCH-31-30-bgo-831903-pip-don-t-fail-with-optional-.patch"
	"${FILESDIR}/0025-Skip-pip-check.patch"
	"${FILESDIR}/0026-bmo-1753182-Resolve-fs-symlinks.patch"
	"${FILESDIR}/0027-Support-for-building-firefox-without-X11.patch"
	"${FILESDIR}/0028-Accept-mold-as-linker.patch"
	"${FILESDIR}/0029-gni-changes-to-disable-x11-dependency.patch"
	"${FILESDIR}/0031-Auto-generated-mozbuild-gn-configs-based-on-gni-chan.patch"
)

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="https://www.mozilla.com/firefox"

KEYWORDS="~amd64"

SLOT="rapid"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"

IUSE="+clang +dbus eme-free"
IUSE+=" lto +mold +openh264 pgo sndio"
IUSE+=" +system-harfbuzz +system-icu +system-jpeg +system-libevent +system-libvpx system-png +system-webp"

REQUIRED_USE="
	pgo? ( lto )
	dbus"

BDEPEND="${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
	dev-util/cbindgen
	net-libs/nodejs
	virtual/pkgconfig
	virtual/rust
	sys-devel/clang
	sys-devel/llvm
	clang? (
		sys-devel/lld
		pgo? ( sys-libs/compiler-rt-sanitizers[profile] )
	)
	dev-lang/nasm"

COMMON_DEPEND="
	dev-libs/nss
	dev-libs/nspr
	dev-libs/atk
	dev-libs/expat
	x11-libs/cairo
	x11-libs/gtk+
	x11-libs/gdk-pixbuf
	x11-libs/pango
	media-libs/mesa
	media-libs/fontconfig
	media-libs/freetype
	kernel_linux? ( media-libs/alsa-lib )
	virtual/freedesktop-icon-theme
	x11-libs/pixman
	dev-libs/glib
	sys-libs/zlib
	dev-libs/libffi
	media-video/ffmpeg
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	media-video/pipewire
	system-harfbuzz? (
		media-libs/harfbuzz
		media-gfx/graphite2
	)
	system-icu? ( dev-libs/icu )
	system-jpeg? ( media-libs/libjpeg-turbo )
	system-libevent? ( dev-libs/libevent[threads] )
	system-libvpx? ( media-libs/libvpx[postproc] )
	system-png? ( media-libs/libpng[apng] )
	system-webp? ( media-libs/libwebp )
	sndio? ( media-sound/sndio )"

RDEPEND="${COMMON_DEPEND}
	!www-client/firefox:0
	!www-client/firefox:esr
	openh264? ( media-libs/openh264[plugin] )"

DEPEND="${COMMON_DEPEND}
	x11-libs/gtk+[wayland]"

S="${WORKDIR}/${PN}-${PV%_*}"

# Allow MOZ_GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z "${MOZ_GMP_PLUGIN_LIST+set}" ]] ; then
	MOZ_GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

llvm_check_deps() {
	if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
		einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang ; then
		if ! has_version -b "=sys-devel/lld-${LLVM_SLOT}*" ; then
			einfo "=sys-devel/lld-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if use pgo ; then
			if ! has_version -b "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*" ; then
				einfo "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

MOZ_LANGS=(
	en-US
)

moz_clear_vendor_checksums() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -ne 1 ]] ; then
		die "${FUNCNAME} requires exact one argument"
	fi

	einfo "Clearing cargo checksums for ${1} ..."

	sed -i \
		-e 's/\("files":{\)[^}]*/\1/' \
		"${S}"/third_party/rust/${1}/.cargo-checksum.json \
		|| die
}

moz_install_xpi() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local DESTDIR=${1}
	shift

	insinto "${DESTDIR}"

	local emid xpi_file xpi_tmp_dir
	for xpi_file in "${@}" ; do
		emid=
		xpi_tmp_dir=$(mktemp -d --tmpdir="${T}")

		# Unpack XPI
		unzip -qq "${xpi_file}" -d "${xpi_tmp_dir}" || die

		# Determine extension ID
		if [[ -f "${xpi_tmp_dir}/install.rdf" ]] ; then
			emid=$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${xpi_tmp_dir}/install.rdf")
			[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
		elif [[ -f "${xpi_tmp_dir}/manifest.json" ]] ; then
			emid=$(sed -n -e 's/.*"id": "\([^"]*\)".*/\1/p' "${xpi_tmp_dir}/manifest.json")
			[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
		else
			die "failed to determine extension id"
		fi

		einfo "Installing ${emid}.xpi into ${ED}${DESTDIR} ..."
		newins "${xpi_file}" "${emid}.xpi"
	done
}

mozconfig_add_options_ac() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

mozconfig_use_with() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_with "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has usersandbox $FEATURES ; then
				die "You must enable usersandbox as X server can not run as root!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6500M"
		fi

		check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has userpriv ${FEATURES} ; then
				eerror "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6400M"
		fi

		check-reqs_pkg_setup

		llvm_pkg_setup

		if use clang && use lto ; then
			local version_lld=$(ld.lld --version 2>/dev/null | awk '{ print $2 }')
			[[ -n ${version_lld} ]] && version_lld=$(ver_cut 1 "${version_lld}")
			[[ -z ${version_lld} ]] && die "Failed to read ld.lld version!"

			# temp fix for https://bugs.gentoo.org/768543
			# we can assume that rust 1.{49,50}.0 always uses llvm 11
			local version_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'release:' | awk '{ print $2 }')
			[[ -n ${version_rust} ]] && version_rust=$(ver_cut 1-2 "${version_rust}")
			[[ -z ${version_rust} ]] && die "Failed to read version from rustc!"

			if ver_test "${version_rust}" -ge "1.49" && ver_test "${version_rust}" -le "1.50" ; then
				local version_llvm_rust="11"
			else
				local version_llvm_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'LLVM version:' | awk '{ print $3 }')
				[[ -n ${version_llvm_rust} ]] && version_llvm_rust=$(ver_cut 1 "${version_llvm_rust}")
				[[ -z ${version_llvm_rust} ]] && die "Failed to read used LLVM version from rustc!"
			fi

			if ver_test "${version_lld}" -ne "${version_llvm_rust}" ; then
				eerror "Rust is using LLVM version ${version_llvm_rust} but ld.lld version belongs to LLVM version ${version_lld}."
				eerror "You will be unable to link ${CATEGORY}/${PN}. To proceed you have the following options:"
				eerror "  - Manually switch rust version using 'eselect rust' to match used LLVM version"
				eerror "  - Switch to dev-lang/rust[system-llvm] which will guarantee matching version"
				eerror "  - Build ${CATEGORY}/${PN} without USE=lto"
				die "LLVM version used by Rust (${version_llvm_rust}) does not match with ld.lld version (${version_lld})!"
			fi
		fi

		if ! use clang && [[ $(gcc-major-version) -eq 11 ]] \
			&& ! has_version -b ">sys-devel/gcc-11.1.0:11" ; then
			# bug 792705
			eerror "Using GCC 11 to compile firefox is currently known to be broken (see bug #792705)."
			die "Set USE=clang or select <gcc-11 to build ${CATEGORY}/${P}."
		fi

		python-any-r1_pkg_setup

		# Avoid PGO profiling problems due to enviroment leakage
		# These should *always* be cleaned up anyway
		unset \
			DBUS_SESSION_BUS_ADDRESS \
			DISPLAY \
			ORBIT_SOCKETDIR \
			SESSION_MANAGER \
			XAUTHORITY \
			XDG_CACHE_HOME \
			XDG_SESSION_COOKIE

		# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict /proc/self/oom_score_adj

		if use pgo ; then
			# Allow access to GPU during PGO run
			local mesa_cards render_cards
			shopt -s nullglob

			mesa_cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
			if [[ -n "${mesa_cards}" ]] ; then
				addpredict "${mesa_cards}"
			fi

			render_cards=$(echo -n /dev/dri/renderD128* | sed 's/ /:/g')
			if [[ -n "${render_cards}" ]] ; then
				addpredict "${render_cards}"
			fi

			shopt -u nullglob
		fi

		if ! mountpoint -q /dev/shm ; then
			# If /dev/shm is not available, configure is known to fail with
			# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
			ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

		# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
		# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
		# get your own set of keys.
		if [[ -z "${MOZ_API_KEY_GOOGLE+set}" ]] ; then
			MOZ_API_KEY_GOOGLE="AIzaSyDEAOvatFogGaPi0eTgsV_ZlEzx0ObmepsMzfAc"
		fi

		if [[ -z "${MOZ_API_KEY_LOCATION+set}" ]] ; then
			MOZ_API_KEY_LOCATION="AIzaSyB2h2OuRgGaPicUgy5N-5hsZqiPW6sH3n_rptiQ"
		fi

		# Mozilla API keys (see https://location.services.mozilla.com/api)
		# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
		# get your own set of keys.
		if [[ -z "${MOZ_API_KEY_MOZILLA+set}" ]] ; then
			MOZ_API_KEY_MOZILLA="edb3d487-3a84-46m0ap1e3-9dfd-92b5efaaa005"
		fi

		# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi

	CONFIG_CHECK="~SECCOMP"
	WARNING_SECCOMP="CONFIG_SECCOMP not set! This system will be unable to play DRM-protected content."
	linux-info_pkg_setup
}

src_unpack() {
	local _lp_dir="${WORKDIR}/language_packs"
	local _src_file

	if [[ ! -d "${_lp_dir}" ]] ; then
		mkdir "${_lp_dir}" || die
	fi

	for _src_file in ${A} ; do
		if [[ ${_src_file} == *.xpi ]]; then
			cp "${DISTDIR}/${_src_file}" "${_lp_dir}" || die "Failed to copy '${_src_file}' to '${_lp_dir}'!"
		else
			unpack ${_src_file}
		fi
	done
}

src_prepare() {
	if ! use lto ; then
		eapply "${FILESDIR}/0018-LTO-Only-enable-LTO-for-Rust-when-complete-build-use.patch"
	fi

	default

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	# Make LTO respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/build/moz.configure/lto-pgo.configure \
		|| die "sed failed to set num_cores"

	# Make ICU respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/intl/icu_sources_data.py \
		|| die "sed failed to set num_cores"

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		"${S}"/python/mozbuild/mozbuild/configure/check_debug_ranges.py \
		|| die "sed failed to set toolchain prefix"

	sed -i \
		-e 's/ccache_stats = None/return None/' \
		"${S}"/python/mozbuild/mozbuild/controller/building.py \
		|| die "sed failed to disable ccache stats call"

	einfo "Removing pre-built binaries ..."
	find "${S}"/third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	# Clearing checksums where we have applied patches
	moz_clear_vendor_checksums target-lexicon-0.9.0

	# Create build dir
	BUILD_DIR="${WORKDIR}/${PN}_build"
	mkdir -p "${BUILD_DIR}" || die

	# Write API keys to disk
	echo -n "${MOZ_API_KEY_GOOGLE//gGaPi/}" > "${S}"/api-google.key || die
	echo -n "${MOZ_API_KEY_LOCATION//gGaPi/}" > "${S}"/api-location.key || die
	echo -n "${MOZ_API_KEY_MOZILLA//m0ap1/}" > "${S}"/api-mozilla.key || die
}

src_configure() {
	# Show flags set at the beginning
	einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	local have_switched_compiler=
	if use clang && ! tc-is-clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		have_switched_compiler=yes
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	# Set MOZILLA_FIVE_HOME
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Set state path
	export MOZBUILD_STATE_PATH="${BUILD_DIR}"

	# Set MOZCONFIG
	export MOZCONFIG="${S}/.mozconfig"

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-application=browser

	# Set Gentoo defaults
	export MOZILLA_OFFICIAL=1

	mozconfig_add_options_ac 'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-pulseaudio \
		--disable-install-strip \
		--disable-parental-controls \
		--disable-strip \
		--disable-updater \
		--enable-negotiateauth \
		--enable-new-pass-manager \
		--enable-official-branding \
		--enable-release \
		--enable-system-ffi \
		--enable-system-pixman \
		--host="${CBUILD:-${CHOST}}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--target="${CHOST}" \
		--without-ccache \
		--without-wasm-sandboxed-libraries \
		--with-intl-api \
		--with-libclang-path="$(llvm-config --libdir)" \
		--with-system-nspr \
		--with-system-nss \
		--with-system-zlib \
		--with-toolchain-prefix="${CHOST}-" \
		--with-unsigned-addon-scopes=app,system \
		--x-includes="${SYSROOT}${EPREFIX}/usr/include" \
		--x-libraries="${SYSROOT}${EPREFIX}/usr/$(get_libdir)"

	# Set update channel
	mozconfig_add_options_ac '' --update-channel=release
	mozconfig_add_options_ac '' --enable-sandbox

	einfo "Building without Google API key ..."
	einfo "Building without Location API key ..."

	if [[ -s "${S}/api-mozilla.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${S}/api-mozilla.key" | md5sum | awk '{ print $1 }') != 3927726e9442a8e8fa0e46ccc39caa27 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-mozilla-api-keyfile="${S}/api-mozilla.key"
	else
		einfo "Building without Mozilla API key ..."
	fi

	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_with system-icu
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-libevent
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-png
	mozconfig_use_with system-webp

	mozconfig_use_enable dbus

	use eme-free && mozconfig_add_options_ac '+eme-free' --disable-eme

	mozconfig_use_enable sndio

	mozconfig_add_options_ac '+wayland' --enable-default-toolkit=cairo-gtk3-wayland
	mozconfig_add_options_ac '+debug' --disable-optimize

	if use lto ; then
		if use clang ; then
			# Upstream only supports lld when using clang
			if use mold ; then
				mozconfig_add_options_ac "forcing ld=mold due to USE=clang and USE=lto" --enable-linker=mold
			else
				mozconfig_add_options_ac "forcing ld=lld due to USE=clang and USE=lto" --enable-linker=lld
			fi

			mozconfig_add_options_ac '+lto' --enable-lto=cross

		else
			# ThinLTO is currently broken, see bmo#1644409
			mozconfig_add_options_ac '+lto' --enable-lto=full
			if use mold ; then
				mozconfig_add_options_ac "linker is set to mold" --enable-linker=mold
			else
				mozconfig_add_options_ac "linker is set to bfd" --enable-linker=bfd
			fi
		fi

		if use pgo ; then
			mozconfig_add_options_ac '+pgo' MOZ_PGO=1

			if use clang ; then
				# Used in build/pgo/profileserver.py
				export LLVM_PROFDATA="llvm-profdata"
			fi
		fi
	else
		# Avoid auto-magic on linker
		if use clang ; then
			# This is upstream's default
			if use mold; then
				mozconfig_add_options_ac "forcing ld=mold due to USE=clang" --enable-linker=mold
			else
				mozconfig_add_options_ac "forcing ld=lld due to USE=clang" --enable-linker=lld
			fi
		else
			if use mold; then
				mozconfig_add_options_ac "linker is set to mold" --enable-linker=mold
			else
				mozconfig_add_options_ac "linker is set to bfd" --enable-linker=bfd
			fi
		fi
	fi

	mozconfig_add_options_ac 'Gentoo default' --disable-debug-symbols
	mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O3

	filter-flags '-flto*'
	filter-flags '-g*'
	filter-flags '-O*'

	if use clang ; then
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1482204
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1483822
		# toolkit/moz.configure Elfhack section: target.cpu in ('arm', 'x86', 'x86_64')
		local disable_elf_hack=
		disable_elf_hack=yes

		if [[ -n ${disable_elf_hack} ]] ; then
			mozconfig_add_options_ac 'elf-hack is broken when using Clang' --disable-elf-hack
		fi
	elif tc-is-gcc ; then
		if ver_test $(gcc-fullversion) -ge 10 ; then
			einfo "Forcing -fno-tree-loop-vectorize to workaround GCC bug, see bug 758446 ..."
			append-cxxflags -fno-tree-loop-vectorize
		fi
	fi

	if ! use elibc_glibc ; then
		mozconfig_add_options_ac '!elibc_glibc' --disable-jemalloc
	fi

	# Allow elfhack to work in combination with unstripped binaries
	# when they would normally be larger than 2GiB.
	append-ldflags "-Wl,--compress-debug-sections=zlib"

	# Make revdep-rebuild.sh happy; Also required for musl
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Use system's Python environment
	export MACH_USE_SYSTEM_PYTHON=1
	export MACH_SYSTEM_ASSERTED_COMPATIBLE_WITH_MACH_SITE=1
	export MACH_SYSTEM_ASSERTED_COMPATIBLE_WITH_BUILD_SITE=1
	export PIP_NO_CACHE_DIR=off

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support arguments
	mozconfig_add_options_ac 'Gentoo default' "XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk 'Gentoo default' "MOZ_OBJDIR=${BUILD_DIR}"

	# Show flags we will use
	einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Build RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	# Handle EXTRA_CONF and show summary
	local ac opt hash reason

	# Apply EXTRA_ECONF entries to $MOZCONFIG
	if [[ -n ${EXTRA_ECONF} ]] ; then
		IFS=\! read -a ac <<<${EXTRA_ECONF// --/\!}
		for opt in "${ac[@]}"; do
			mozconfig_add_options_ac "EXTRA_ECONF" --${opt#--}
		done
	fi

	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options "${MOZCONFIG}" | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	./mach configure || die
}

src_compile() {
	local virtwl_cmd=

	if use pgo ; then
		local virtwl_cmd=virtwl

		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root
	fi

	local -x GDK_BACKEND=wayland

	${virtwl_cmd} ./mach build --verbose || die
}

src_install() {
	# xpcshell is getting called during install
	pax-mark m \
		"${BUILD_DIR}"/dist/bin/xpcshell \
		"${BUILD_DIR}"/dist/bin/${PN} \
		"${BUILD_DIR}"/dist/bin/plugin-container

	DESTDIR="${D}" ./mach install || die

	# Upstream cannot ship symlink but we can (bmo#658850)
	rm "${ED}${MOZILLA_FIVE_HOME}/${PN}-bin" || die
	dosym ${PN} ${MOZILLA_FIVE_HOME}/${PN}-bin

	# Don't install llvm-symbolizer from sys-devel/llvm package
	if [[ -f "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] ; then
		rm -v "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" || die
	fi

	# Install policy (currently only used to disable application updates)
	insinto "${MOZILLA_FIVE_HOME}/distribution"
	newins "${FILESDIR}"/distribution.ini distribution.ini
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}"/gentoo-default-prefs.js gentoo-prefs.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/gentoo-prefs.js"

	local plugin
	for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
		einfo "Disabling auto-update for ${plugin} plugin ..."
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to disable autoupdate for ${plugin} media plugin"
		pref("media.${plugin}.autoupdate",   false);
		EOF
	done

	# Force the graphite pref if USE=system-harfbuzz is enabled, since the pref cannot disable it
	if use system-harfbuzz ; then
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set gfx.font_rendering.graphite.enabled pref"
		sticky_pref("gfx.font_rendering.graphite.enabled", true);
		EOF
	fi

	# Install icons
	local icon_srcdir="${S}/browser/branding/official"
	local icon_symbolic_file="${FILESDIR}/icon/firefox-symbolic.svg"

	insinto /usr/share/icons/hicolor/symbolic/apps
	newins "${icon_symbolic_file}" ${PN}-symbolic.svg

	local icon size
	for icon in "${icon_srcdir}"/default*.png ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" ${PN}.png
		fi

		newicon -s ${size} "${icon}" ${PN}.png
	done

	# Install menu
	local app_name="Mozilla ${MOZ_PN^}"
	local desktop_file="${FILESDIR}/icon/${PN}-r3.desktop"
	local desktop_filename="${PN}.desktop"
	local exec_command="${PN}"
	local icon="${PN}"

	cp "${desktop_file}" "${WORKDIR}/${PN}.desktop-template" || die

	sed -i \
		-e "s:@NAME@:${app_name}:" \
		-e "s:@EXEC@:${exec_command}:" \
		-e "s:@ICON@:${icon}:" \
		"${WORKDIR}/${PN}.desktop-template" \
		|| die

	newmenu "${WORKDIR}/${PN}.desktop-template" "${desktop_filename}"

	rm "${WORKDIR}/${PN}.desktop-template" || die

	# Install wrapper script
	[[ -f "${ED}/usr/bin/${PN}" ]] && rm "${ED}/usr/bin/${PN}"
	newbin "${FILESDIR}/${PN}-r1.sh" ${PN}

	# Update wrapper
	sed -i \
		-e "s:@PREFIX@:${EPREFIX}/usr:" \
		-e "s:@MOZ_FIVE_HOME@:${MOZILLA_FIVE_HOME}:" \
		-e "s:@APULSELIB_DIR@:${apulselib}:" \
		-e "s:@DEFAULT_WAYLAND@:true:" \
		"${ED}/usr/bin/${PN}" \
		|| die
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Build has disabled the following plugins from updating or"
	elog "installing into new profiles:"
	local plugin
	for plugin in "${MOZ_GMP_PLUGIN_LIST[@]}" ; do
		elog "\t ${plugin}"
	done
	elog

	local show_normandy_information=yes

	if [[ -n "${show_normandy_information}" ]] ; then
		elog
		elog "Upstream operates a service named Normandy which allows Mozilla to"
		elog "push changes for default settings or even install new add-ons remotely."
		elog "While this can be useful to address problems like 'Armagadd-on 2.0' or"
		elog "revert previous decisions to disable TLS 1.0/1.1, privacy and security"
		elog "concerns prevail, which is why we have switched off the use of this"
		elog "service by default."
		elog
		elog "To re-enable this service set"
		elog
		elog "    app.normandy.enabled=true"
		elog
		elog "in about:config."
	fi
}
