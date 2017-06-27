# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 versionator toolchain-funcs

if [[ ${PV} = *beta* ]]; then
    betaver=${PV//*beta}
    BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
    MY_P="rustc-beta"
    SLOT="beta/${PV}"
    SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.gz"
    KEYWORDS=""
else
    ABI_VER="$(get_version_component_range 1-2)"
    SLOT="stable/${ABI_VER}"
    MY_P="rustc-${PV}"
    SRC="${MY_P}-src.tar.gz"
    KEYWORDS="~amd64 ~x86"
fi

CHOST_amd64=x86_64-unknown-linux-gnu
CHOST_x86=i686-unknown-linux-gnu

RUST_STAGE0_VERSION="1.$(($(get_version_component_range 2) - 0)).0"
RUST_STAGE0_amd64="rust-${RUST_STAGE0_VERSION}-${CHOST_amd64}"
RUST_STAGE0_x86="rust-${RUST_STAGE0_VERSION}-${CHOST_x86}"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="clang debug doc libcxx jemalloc +system-llvm"
REQUIRED_USE="libcxx? ( clang )"

RDEPEND="libcxx? ( sys-libs/libcxx )
    system-llvm? ( sys-devel/llvm:= )
"

DEPEND="${RDEPEND}
    ${PYTHON_DEPS}
    >=dev-lang/perl-5.0
    clang? ( sys-devel/clang )
"

PDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
    dev-util/cargo
"

PATCHES=(
    "${FILESDIR}/0001-Factor-out-helper-for-getting-C-runtime-linkage.patch"
    "${FILESDIR}/0002-Link-libgcc_s-over-libunwind-on-musl.patch"
    "${FILESDIR}/0003-Support-dynamic-linking-for-musl-based-targets.patch"
    "${FILESDIR}/0004-Presence-of-libraries-does-not-depend-on-architectur.patch"
    "${FILESDIR}/0005-completely-remove-musl_root-and-its-c-library-overri.patch"
    "${FILESDIR}/0006-liblibc.patch"
)
S="${WORKDIR}/${MY_P}-src"

toml_usex() {
    usex "$1" true false
}

src_prepare() {
    use amd64 && CTARGET="x86_64-unknown-linux-gnu"
    use x86 && CTARGET="i686-unknown-linux-gnu"

    default
}

src_configure() {
    use amd64 && CTARGET="x86_64-unknown-linux-gnu"
    use x86 && CTARGET="i686-unknown-linux-gnu"
    local rust_target_name="CHOST_${ARCH}"
    local rust_target="${!rust_target_name}"

    local archiver="$(tc-getAR)"
    local linker="$(tc-getCC)"

    local llvm_config="${EPREFIX}$(llvm-config --prefix)"
    local c_compiler="$(tc-getBUILD_CC)"
    local cxx_compiler="$(tc-getBUILD_CXX)"

    cat <<- EOF > ${S}/config.toml
[llvm]
optimize = $(toml_usex !debug)
release-debuginfo = $(toml_usex debug)
assertions = $(toml_usex debug)
[build]
build = "${rust_target}"
host = ["${rust_target}"]
target = ["${rust_target}"]
docs = $(toml_usex doc)
submodules = false
python = "${EPYTHON}"
locked-deps = true
vendor = true
verbose = 2
[install]
prefix = "${EPREFIX}/usr"
libdir = "$(get_libdir)"
docdir = "share/doc/${P}"
mandir = "share/${P}/man"
[rust]
optimize = $(toml_usex !debug)
debuginfo = $(toml_usex debug)
debug-assertions = $(toml_usex debug)
use-jemalloc = $(toml_usex jemalloc)
default-linker = "${linker}"
default-ar = "${archiver}"
rpath = false
channel = "${SLOT%%/*}"
[target.${rust_target}]
$(usex system-llvm "llvm-config = \"${llvm_config}/bin/llvm-config\"")
cc = "${c_compiler}"
cxx = "${cxx_compiler}"
EOF
}

src_compile() {
    export RUST_BACKTRACE=1

    ./x.py build --verbose --config="${S}"/config.toml || die
}

src_install() {
    env DESTDIR="${D}" ./x.py dist --install || die

    mv "${D}/usr/bin/rustc" "${D}/usr/bin/rustc-${PV}" || die
    mv "${D}/usr/bin/rustdoc" "${D}/usr/bin/rustdoc-${PV}" || die
    mv "${D}/usr/bin/rust-gdb" "${D}/usr/bin/rust-gdb-${PV}" || die

    dodoc COPYRIGHT

    cat <<-EOF > "${T}"/50${P}
MANPATH="/usr/share/${P}/man"
EOF
    doenvd "${T}"/50${P}

    cat <<-EOF > "${T}/provider-${P}"
/usr/bin/rustdoc
/usr/bin/rust-gdb
EOF
    dodir /etc/env.d/rust
    insinto /etc/env.d/rust
    doins "${T}/provider-${P}"
}

pkg_postinst() {
    eselect rust update --if-unset

    elog "Rust installs a helper script for calling GDB now,"
    elog "for your convenience it is installed under /usr/bin/rust-gdb-${PV}."

    if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
        elog "install app-emacs/rust-mode to get emacs support for rust."
    fi

    if has_version app-editors/gvim || has_version app-editors/vim; then
        elog "install app-vim/rust-vim to get vim support for rust."
    fi

    if has_version 'app-shells/zsh'; then
        elog "install app-shells/rust-zshcomp to get zsh completion for rust."
    fi
}

pkg_postrm() {
    eselect rust unset --if-invalid
}
