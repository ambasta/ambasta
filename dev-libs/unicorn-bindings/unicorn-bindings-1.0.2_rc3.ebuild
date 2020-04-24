# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_/-}

PYTHON_COMPAT=( python3_{7,8} )
inherit multilib distutils-r1

DESCRIPTION="Unicorn bindings"
HOMEPAGE="http://www.unicorn-engine.org"
SRC_URI="https://github.com/unicorn-engine/unicorn/archive/${MY_PV}.tar.gz -> unicorn-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

RDEPEND="~dev-util/unicorn-${PV}"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
	"
#	go? ( dev-lang/go )
#	ruby? ( dev-lang/ruby:* )

S="${WORKDIR}/unicorn-${MY_PV}"/bindings

pkg_setup() {
	python_setup
}

src_prepare(){
	#do not compile C extensions
	export LIBUNICORN_PATH=1

	sed -i -e '/const_generator.py dotnet/d' Makefile
	eapply_user
}

src_compile(){
	einfo "Nothing to compile"
}

src_install(){
	if use python; then
		myinstall_python() {
			emake -C python DESTDIR="${D}" install3
			python_optimize
		}
		python_foreach_impl myinstall_python
	fi
}
