# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $

EAPI=5

inherit autotools
DESCRIPTION="a flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell."
HOMEPAGE="https://github.com/horst3180/${PN}"

SRC_URI="https://github.com/horst3180/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"

DEPEND=">=x11-libs/gtk+-3.14
	x11-themes/gtk-engines-murrine
	virtual/pkgconfig"
RDEPEND=">=x11-libs/gtk+-3.14
	x11-themes/gtk-engines-murrine"

src_prepare(){
	eautoreconf
}

src_install(){
	emake DESTDIR="${D}" install
}
