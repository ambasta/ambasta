# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/pycharm/"
SRC_URI="https://download.jetbrains.com/python/${PN}-$(ver_cut 4-6).tar.gz"

LICENSE="PyCharm_Academic PyCharm_Classroom PyCharm PyCharm_OpenSource PyCharm_Preview"

SLOT="2018"
KEYWORDS="~amd64 ~x86"
IUSE="system-jdk"

RESTRICT="mirror strip splitdebug"

RDEPEND="system-jdk? ( virtual/jdk )
	dev-python/pip"

S="${WORKDIR}/pycharm-$(ver_cut 1-2)"

src_prepare() {
	default

	local remove_me=()

	use arm || remove_me+=( bin/fsnotifier-arm )

	if use system-jdk; then
		remove_me+=( jre64 )
	fi

	rm -rv "${remove_me[@]}" || die
}

src_install() {
	insinto "/opt/${PN}"
	doins -r .
	fperms a+x /opt/${PN}/bin/{pycharm.sh,fsnotifier{,64},inspect.sh}

	if ! use system-jdk; then
        if [[ -d jre64 ]]; then
        	fperms 755 /opt/${PN}/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}
        fi
    fi

	make_wrapper ${PN} /opt/${PN}/bin/pycharm.sh
	newicon bin/pycharm.svg ${PN}.svg
	make_desktop_entry ${PN} ${PN} ${PN} "Development;IDE;"
}
