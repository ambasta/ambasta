# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit user

DESCRIPTION="The open-source database for the realtime web."
HOMEPAGE="http://www.rethinkdb.com"
LICENSE="AGPL-3"
SLOT="0"
SRC_URI="https://download.rethinkdb.com/dist/${P}.tgz"
KEYWORDS="~amd64 ~x86"
IUSE="doc +jemalloc tcmalloc"

# TODO: rly need some webui libs ?
DEPEND="dev-cpp/gtest
		dev-libs/boost
		dev-libs/protobuf-c
		dev-libs/re2
		sys-libs/libunwind
		sys-libs/ncurses:=
		jemalloc? ( >=dev-libs/jemalloc-3.2 )
		tcmalloc? ( dev-util/google-perftools )"
RDEPEND="${DEPEND}"
REQUIRED_USE="?? ( tcmalloc jemalloc )"

pkg_setup() {
	enewgroup rethinkdb
	enewuser rethinkdb -1 -1 /var/lib/${PN} rethinkdb
}

src_prepare() {
	# fix doc installation
	sed -e 's/ install-docs / /g' -i mk/install.mk || die

	# default config
	# fix default pid-file path
	# fix default directory path
	# fix default log-file path
	sed -e 's@/var/run/@/run/@g' \
		-e 's@/var/lib/rethinkdb/@/var/lib/rethinkdb/instances.d/@g' \
		-e 's@/var/log/rethinkdb@/var/log/rethinkdb/default.log@g' \
		-i packaging/assets/config/default.conf.sample || die

	# fix termcap detection
	sed -e 's/termcap:termcap tinfo ncurses/termcap:ncurses termcap tinfo/g' -i configure || die

	# fix doc installation
	sed -e 's/ install-init / /g' -i mk/install.mk || die

	# v8 has to be bundled
	# use dynamic libs
	local myopts="--fetch v8 --dynamic all --dynamic gtest --dynamic re2"
	if use tcmalloc ; then
		myopts+=" --with-tcmalloc"
	else
		myopts+=" --with-jemalloc"
	fi
	echo "${myopts}" > configure.default
}

src_configure() {
	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
}

src_install() {
	emake DESTDIR="${D}" install

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners rethinkdb:rethinkdb "${x}"
	done

	newconfd "${FILESDIR}/rethinkdb.confd" rethinkdb
	newinitd "${FILESDIR}/rethinkdb.initd" rethinkdb

	use doc && dodoc COPYRIGHT NOTES.md README.md
}
