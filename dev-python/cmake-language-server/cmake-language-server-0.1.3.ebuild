# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="CMake LSP Implementation."
HOMEPAGE="https://github.com/regen100/cmake-language-server"
LICENSE="MIT"
SLOT="0"
MY_PV="a5af5b505f8810760168dc250caf8404370b15c3"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/regen100/cmake-language-server"
    inherit git-r3
else
	SRC_URI="https://github.com/regen100/${PN}/archive/${MY_PV}.zip -> ${P}.zip"
    KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DEPEND="
	>=dev-python/pygls-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-python/setuptools_scm-2.0.0[${PYTHON_USEDEP}]"
