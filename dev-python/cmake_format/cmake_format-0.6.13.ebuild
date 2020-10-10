# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{7,8,9} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Source code formatter for cmake listfiles"
HOMEPAGE="https://github.com/cheshirekow/cmake_format"
SRC_URI="https://github.com/cheshirekow/cmake_format/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# tests connect to various remote sites
RESTRICT="test"

#DEPEND+="
#	test? (
#		dev-python/pytest[${PYTHON_USEDEP}]
#		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
#		dev-python/pytest-mock[${PYTHON_USEDEP}]
#		dev-python/pytest-xdist[${PYTHON_USEDEP}]
#		>=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}]
#	)
#"

python_test() {
	py.test || die
}
