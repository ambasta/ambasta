# Copyright 2008-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils elisp-common flag-o-matic multilib-minimal toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/24"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="emacs examples static-libs test zlib"
RESTRICT="!test? ( test )"

BDEPEND="emacs? ( app-editors/emacs:* )"
DEPEND="test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
RDEPEND="emacs? ( app-editors/emacs:* )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"

# PATCHES=(
# 	"${FILESDIR}/${PN}-3.13.0-protoc_input_output_files.patch"
# )

DOCS=(CHANGES.txt CONTRIBUTORS.txt README.md)

CMAKE_USE_DIR=${S}/cmake

src_prepare() {
	default

	# https://github.com/protocolbuffers/protobuf/issues/7682
	sed -e "/^[[:space:]]*static_assert(alignof(T) <= 8, \"T is overaligned, see b\/151247138\");$/d" -i src/google/protobuf/arena.h || die
	cmake-utils_src_prepare
}

src_configure() {
	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI

	if tc-ld-is-gold; then
		# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-Dprotobuf_WITH_ZLIB=$(usex zlib)
		-Dprotobuf_BUILD_TESTS=OFF
	)

	if tc-is-cross-compiler; then
		mycmakeargs+=(-DCMAKE_CROSSCOMPILING=ON)
	fi
	cmake-utils_src_configure
}

src_compile() {
	multilib-minimal_src_compile

	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

multilib_src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}/build/src" protoc
	fi

	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${D}" -name "*.a" -delete || die
	fi

	insinto /usr/share/vim/vimfiles/syntax
	doins editors/proto.vim
	insinto /usr/share/vim/vimfiles/ftdetect
	doins "${FILESDIR}/proto.vim"

	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		DOCS+=(examples)
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
