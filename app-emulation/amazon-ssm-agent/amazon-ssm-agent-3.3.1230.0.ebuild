EAPI=8

inherit autotools go-module systemd

DESCRIPTION="AWS SSM Agent"
HOMEPAGE="https://github.com/aws/amazon-ssm-agent/"
SRC_URI="https://github.com/aws/amazon-ssm-agent/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT=0
KEYWORDS="~amd64 ~arm64"

BDEPEND="dev-lang/go"
REPENDS=""

src_compile() {
	local goarch
	if use amd64; then
		goarch="amd64"
	elif use arm64; then
		goarch="arm64"
	else
		die "Unsupported architecture"
	fi

	# Compile with the correct architecture
	GOOS=linux GOARCH=${goarch} emake build-linux
}

src_install() {
	keepdir /var/log/aws
	dobin bin/linux_amd64/*
	systemd_dounit packaging/linux/amazon-ssm-agent.service
}
