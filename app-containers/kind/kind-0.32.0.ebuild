# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module toolchain-funcs

DESCRIPTION="Run local Kubernetes clusters using Docker container nodes"
HOMEPAGE="https://kind.sigs.k8s.io https://github.com/kubernetes-sigs/kind"
SRC_URI="https://github.com/kubernetes-sigs/kind/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/ambasta/ambasta/main/app-containers/kind/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hardened"

RDEPEND="|| (
	app-containers/docker
	app-containers/podman
)"

RESTRICT="test"

src_prepare() {
	ln -sv ../vendor ./ || die
	default
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		ego build -trimpath -ldflags="-buildid= -s -w" -o bin/${PN} .
}

src_install() {
	dobin bin/${PN}
	dodoc README.md

	if ! tc-is-cross-compiler; then
		bin/${PN} completion bash >"${T}/${PN}.bash" || die
		bin/${PN} completion fish >"${T}/${PN}.fish" || die
		bin/${PN} completion zsh >"${T}/${PN}.zsh" || die

		newbashcomp "${T}/${PN}.bash" ${PN}
		insinto /usr/share/fish/vendor_completions.d
		newins "${T}/${PN}.fish" ${PN}.fish
		insinto /usr/share/zsh/site-functions
		newins "${T}/${PN}.zsh" _${PN}
	fi
}
