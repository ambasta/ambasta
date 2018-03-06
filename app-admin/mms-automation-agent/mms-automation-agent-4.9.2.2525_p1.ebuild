# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user

MY_PV=${PV/_p/-}

DESCRIPTION="MongoDB MMS agents"
HOMEPAGE="http://cloud.mongodb.com"
SRC_URI="https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-${MY_PV}.linux_x86_64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!<dev-db/mongodb-3.0.0[mms-agent]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/mongodb-mms-automation-agent-${MY_PV}.linux_x86_64"

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb
}

src_install() {
	local MY_PN="mms-automation-agent"
	local MY_D="/opt/${MY_PN}"

	insinto ${MY_D}
	doins mongodb-mms-automation-agent
	fperms +x "${MY_D}"/mongodb-mms-automation-agent

	insinto /etc
	doins local.config
	rm local.config
	dosym ../../etc/automation-agent.config ${MY_D}/local.config

	fowners -R mongodb:mongodb ${MY_D}
}

pkg_postinst() {
	elog "MMS Automation Agent configuration file :"
	elog " /etc/automation-agent.config"
}
