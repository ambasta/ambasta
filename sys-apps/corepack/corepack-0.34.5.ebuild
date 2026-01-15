# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

DESCRIPTION="Fast, reliable, and secure node dependency management"
HOMEPAGE="https://yarnpkg.com"
SRC_URI="https://github.com/nodejs/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="!dev-util/cmdtest
	net-libs/nodejs[-npm,-corepack]
	!sys-apps/yarn"
DEPEND="${RDEPEND}"

# S="${WORKDIR}/${P}"

src_prepare() {
	default
	sed -i 's/"installationMethod": "tar"/"installationMethod": "portage"/g' "${S}/package.json" || die
}

src_install() {
	local bin
	local install_dir
	local path
	local shebang

	install_dir="/usr/$(get_libdir)/node_modules/corepack"
	insinto "${install_dir}"
	doins -r .

	for bin in corepack npm npx pnpm pnpx yarn; do
		dosym "../$(get_libdir)/node_modules/corepack/dist/${bin}.js" "/usr/bin/${bin}"
	done

	while read -r -d '' path; do
		[[ -s "${ED}${path}" ]] || continue
		read -r shebang <"${ED}${path}" || continue
		[[ "${shebang}" == \#\!* ]] || continue
		fperms +x "${path}"
	done < <(find "${ED}" -type f -printf '/%P\0' || die)
}
