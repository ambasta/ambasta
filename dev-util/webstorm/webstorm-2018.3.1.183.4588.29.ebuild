# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="JavaScript IDE for client- and server-side development with Node.js"
HOMEPAGE="http://www.jetbrains.com/webstorm"
SRC_URI="http://download.jetbrains.com/${PN}/WebStorm-$(ver_cut 4-6).tar.gz"

LICENSE="WebStorm WebStorm_Academic WebStorm_Classroom WebStorm_OpenSource WebStorm_personal"


SLOT="2018"
KEYWORDS="~amd64 ~x86"
IUSE="custom-jdk"

RESTRICT="splitdebug"

RDEPEND="!custom-jdk? ( virtual/jdk )"

S="${WORKDIR}/WebStorm-$(ver_cut 4-6)"


src_prepare() {
	default

	local remove_me=()

	use arm || remove_me+=( bin/fsnotifier-arm )
	use custom-jdk || remove_me+=( jre64 )

	rm -rv "${remove_me[@]}" || die
}


src_install() {
	insinto "/opt/${PN}"
	doins -r .
	fperms 755 /opt/${PN}/bin/{${PN}.sh,fsnotifier{,64}}

	if use custom-jdk; then
        if [[ -d jre64 ]]; then
        fperms 755 /opt/${PN}/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}
        fi
    fi

	make_wrapper "${PN}" "/opt/${PN}/bin/${PN}.sh"
}
