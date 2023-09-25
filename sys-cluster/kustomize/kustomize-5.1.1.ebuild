# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module toolchain-funcs

DESCRIPTION="Customization of kubernetes YAML configurations"
HOMEPAGE="https://kustomize.io/"
SRC_URI="https://github.com/kubernetes-sigs/${PN}/archive/${PN}/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/ambasta/${PN}/releases/download/${PV}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${PN}-v${PV}/${PN}"
NONFATAL_VERIFY=1

# src_unpack() {
# 	if use amd64 || use arm || use arm64 ||
# 		( use ppc64 && [[ $(tc-endian) == "little" ]] ) || use s390 || use x86; then
# 			GOFLAGS="-buildmode=pie ${GOFLAGS}"
# 	fi
# 	GOFLAGS="${GOFLAGS} -p=$(makeopts_jobs)"
# 	if [[ "${#EGO_SUM[@]}" -gt 0 ]]; then
# 		eqawarn "This ebuild uses EGO_SUM which is deprecated"
# 		eqawarn "Please migrate to a dependency tarball"
# 		eqawarn "This will become a fatal error in the future"
# 		_go-module_src_unpack_gosum
# 	elif [[ "${#EGO_VENDOR[@]}" -gt 0 ]]; then
# 		eerror "${EBUILD} is using EGO_VENDOR which is no longer supported"
# 		die "Please update this ebuild"
# 	else
# 		default
# 		if [[ ! -d "${S}"/vendor ]]; then
# 			cd "${S}"
# 			local nf
# 			[[ -n ${NONFATAL_VERIFY} ]] && nf=nonfatal
# 		fi
# 	fi
# }
#
# src_compile() {
# 	GOBIN="${S}/bin" emake ${PN}
# }
#
# src_install() {
# 	dobin build/${PN}
# 	default
# }

src_compile() {
	ego build
}

src_install() {
	dobin ${PN}

	default
}
