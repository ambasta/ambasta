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
	local install_dir="/usr/$(get_libdir)/node_modules/corepack" path shebang
	insinto "${install_dir}"
	doins -r .
	dosym "../$(get_libdir)/node_modules/corepack/dist/corepack.js" "/usr/bin/corepack"
	dosym "../$(get_libdir)/node_modules/corepack/dist/npm.js" "/usr/bin/npm"
	dosym "../$(get_libdir)/node_modules/corepack/dist/npx.js" "/usr/bin/npx"
	dosym "../$(get_libdir)/node_modules/corepack/dist/pnpm.js" "/usr/bin/pnpm"
	dosym "../$(get_libdir)/node_modules/corepack/dist/pnpx.js" "/usr/bin/pnpx"
	dosym "../$(get_libdir)/node_modules/corepack/dist/yarn.js" "/usr/bin/yarn"
	dosym "../$(get_libdir)/node_modules/corepack/bin/yarnpkg.js" "/usr/bin/yarnpkg"

	while read -r -d '' path; do
		einfo "Checking permissions for: ${ED}${path}" # Add this
		read -r shebang <"${ED}${path}" || die
		[[ "${shebang}" == \#\!* ]] || continue
		fperms +x "${path}"
	done < <(find "${ED}" -type f -printf '/%P\0' || die)
}
