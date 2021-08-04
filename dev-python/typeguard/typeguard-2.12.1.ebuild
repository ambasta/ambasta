# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Run-time type checking for functions defined with PEP 484"
HOMEPAGE="https://github.com/agronholm/typeguard"
LICENSE="MIT"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/agronholm/${PN}"
    inherit git-r3
else
	SRC_URI="https://github.com/agronholm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi
