EAPI=8

inherit go-module bash-completion-r1

DESCRIPTION=""
HOMEPAGE=""

SRC_URI="https://github.com/open-policy-agent/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"

KEYWORDS="~amd64"

LICENSE="Apache-2.0"

src_compile() {
	make build
	mv opa_linux_amd64 opa
}

src_install() {
	dobin opa
}
