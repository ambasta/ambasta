# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="JavaScript IDE for client- and server-side development with Node.js"
HOMEPAGE="http://www.jetbrains.com/webstorm"
SRC_URI="http://download.jetbrains.com/${PN}/WebStorm-$(ver_cut 4-6).tar.gz"
# SRC_URI="http://download-cf.jetbrains.com/${PN}/WebStorm-$(ver_cut 1-2).tar.gz"

LICENSE="WebStorm WebStorm_Academic WebStorm_Classroom WebStorm_OpenSource WebStorm_personal"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"
IUSE="custom-jdk"
RDEPEND="!custom-jdk? ( virtual/jdk )"

QA_PREBUILT="opt/${P}/*"

S="${WORKDIR}/WebStorm-$(ver_cut 4-6)"

src_prepare() {
	default

	local remove_me=()

	use arm || remove_me+=( bin/fsnotifier-arm )
	use custom-jdk || remove_me+=( jre64 )

	rm -rv "${remove_me[@]}" || die
}

src_install() {
	local dir="/opt/${P}"
	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{webstorm.sh,fsnotifier{,64}}

	if use custom-jdk; then
        if [[ -d jre64 ]]; then
        fperms 755 "${dir}"/jre64/bin/{java,jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200}
        fi
    fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
}
