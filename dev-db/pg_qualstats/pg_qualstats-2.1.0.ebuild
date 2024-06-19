# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=(14 15 16)
POSTGRES_USEDEP="server"

# DISTUTILS_USE_PEP517=setuptools
# PYTHON_COMPAT=(python3_{10..12})

inherit postgres-multi

DESCRIPTION=" A PostgreSQL extension for collecting statistics about predicates, helping find what indices are missing"
HOMEPAGE="https://github.com/powa-team/pg_qualstats"
SRC_URI="https://github.com/powa-team/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
SLOT="0"
LICENSE="Apache-2.0"

IUSE="static-libs"

BDEPEND="
	${POSTGRES_DEP}
"

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install
	use static-libs || find "${ED}" -name '*.a' -delete
}
