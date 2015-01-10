# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{3_2,3_3,3_4} )
PYTHON_REQ_USE="xml"

inherit autotools eutils python-r1 gnome2 systemd

MY_P="${PN%-gnome}-${PV}"
MY_V="$(get_version_component_range 1-2)"

echo ${MY_V}

DESCRIPTION="Red Hat's printer administration tool"
HOMEPAGE="http://cyberelk.net/tim/software/system-config-printer/"
SRC_URI="http://cyberelk.net/tim/data/system-config-printer/${MY_V}/${MY_P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
SLOT="0"
IUSE="doc gnome-keyring policykit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Needs cups running, bug 284005
RESTRICT="test"

# Additional unhandled dependencies:
# net-firewall/firewalld[${PYTHON_USEDEP}]
# gnome-extra/gnome-packagekit[${PYTHON_USEDEP}] with pygobject:2 ?
# python samba client: smbc
# selinux: needed for troubleshooting
COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pycups-1.9.60[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-print/cups[dbus]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
	virtual/libusb:1
	>=virtual/udev-172
	gnome-keyring? ( gnome-base/libgnome-keyring[introspection] )
"
DEPEND="${COMMON_DEPEND}
	!<app-admin/system-config-printer-common-${PV}
	!<app-admin/system-config-printer-gnome-${PV}
	app-arch/xz-utils
	app-text/docbook-xml-dtd:4.1.2
	>=app-text/xmlto-0.0.22
	dev-util/desktop-file-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	policykit? ( >=sys-auth/polkit-0.104-r1 )
"

APP_LINGUAS="ar as bg bn_IN bn br bs ca cs cy da de el en_GB es et fa fi fr gu
he hi hr hu hy id is it ja ka kn ko lo lv mai mk ml mr ms nb nl nn or pa pl
pt_BR pt ro ru si sk sl sr@latin sr sv ta te th tr uk vi zh_CN zh_TW"
for X in ${APP_LINGUAS}; do
	IUSE="${IUSE} linguas_${X}"
done

S="${WORKDIR}/${MY_P}"

# Bug 471472
MAKEOPTS+=" -j1"

pkg_setup() {
	python_setup
}

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	local myconf

	# Disable installation of translations when LINGUAS not chosen
	if [[ -z "${LINGUAS}" ]]; then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls"
	fi

	gnome2_src_configure \
		--with-desktop-vendor=Gentoo \
		--with-udev-rules \
		$(systemd_with_unitdir) \
		${myconf}
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	default

	use doc && dohtml -r html/

	gnome2_src_install
	python_fix_shebang "${ED}"
}
