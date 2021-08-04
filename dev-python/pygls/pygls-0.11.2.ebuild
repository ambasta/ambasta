# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Generic implementation of the Language Server Protocol"
HOMEPAGE="https://github.com/openlawlibrary/pygls/"
LICENSE="Apache-2.0"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/openlawlibrary/${PN}"
    inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
    KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi


DEPEND="
	<=dev-python/pydantic-1.9.0
	<=dev-python/typeguard-3.0.0"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-python/setuptools_scm-2.0.0[${PYTHON_USEDEP}]"
