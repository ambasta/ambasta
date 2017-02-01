# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools
DESCRIPTION="the Paper theme official icons."
HOMEPAGE="https://github.com/snwh/${PN}"

SRC_URI="https://github.com/snwh/paper-icon-theme/archive/v${PV}.tar.gz"
SLOT="0"

KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}
