# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION="Hexdump utility by Juergen Weigert"
HOMEPAGE="https://github.com/ConorOG/xxd"
EGIT_REPO_URI="https://github.com/ConorOG/xxd.git"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	dobin xxd
}
