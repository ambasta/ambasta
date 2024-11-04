EAPI=8

inherit autotools

DESCRIPTION="AWS SSM Agent"
HOMEPAGE="https://github.com/aws/amazon-ssm-agent/"
SRC_URI="https://github.com/aws/amazon-ssm-agent/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT=0
KEYWORDS="~amd64 ~arm64"

BDEPENDS="dev-lang/go"
DEPENDS="dev-lang/go"

src_compile() {
	emake build-linux
}

src_install() {
	keepdir /var/log/aws
	dobin bin/linux_arm64/*
	systemd_dounit amazon-ssm-agent.service
}
