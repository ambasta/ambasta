# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="Modern, beautiful IRC client written in GTK+ 3"
HOMEPAGE="https://github.com/SrainApp/srain"
SRC_URI="https://github.com/SrainApp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug doc man"

RDEPEND="
	>=x11-libs/gtk+-3.22.0
	x11-libs/libnotify
"
DEPEND="
	${RDEPEND}
	app-crypt/libsecret
	dev-libs/libconfig
	net-libs/libsoup
"
BDEPEND="doc? ( dev-python/sphinx )"

src_prepare() {
	sed -i "s/'doc', meson.project_name())/'doc', meson.project_name() + '-${PV}')/" \
		meson.build || die

	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		--buildtype $(usex debug 'debug' 'plain')
	)

	if use man && use doc; then
		emesonargs+=(-Ddoc_builders="[\"man\",\"html\"]")
	elif use man; then
		emesonargs+=(-Ddoc_builders="[\"man\"]")
	elif use doc; then
		emesonargs+=(-Ddoc_builders="[\"html\"]")
	else
		emesonargs+=(-Ddoc_builders="[]")
	fi
	meson_src_configure
}
