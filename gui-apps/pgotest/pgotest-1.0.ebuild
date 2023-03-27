# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gnome2-utils

DESCRIPTION="A simple C++ program with PGO support"
HOMEPAGE="https://www.example.com"
SRC_URI="https://www.example/com/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pgo X"

DEPEND="pgo? (
	gui-libs/gtk:4[X?]
)"
RDEPEND="${DEPEND}"
BDEPEND=""


src_configure() {
	local mycmakeargs=(
		-DUSE_PGO=$(usex pgo)
	)
	cmake_src_configure
}

virtwl() {
	debug-print-function ${FUNCNAME} "$@"

	addpredict /dev/dri

	local user_runtime_dir="/tmp/fakeroot-run/user/1000"
	mkdir -p "${user_runtime_dir}"
	chmod 0700 "${user_runtime_dir}"

	fakeroot -- sh -c "
		chown -R 1000:1000 '${user_runtime_dir}';
		export XDG_RUNTIME_DIR='${user_runtime_dir}';
		export WAYLAND_DISPLAY=wayland-0;
		export WLR_RENDERER=vulkan;
		sway -d >/dev/null 2>&1 & sway_pid=\$!;
		sleep 3;
		$1 || exit 1;
		kill \${sway_pid};
		wait \${sway_pid} || exit 1;
	" || die "virtwl failed"
}

src_compile() {
	local virtx_cmd=

	if use pgo; then
		gnome2_environment_reset

		if ! use X; then
			virtx_cmd=virtwl
		fi
	fi

	if ! use X; then
		local -x GDK_BACKEND=wayland
	else
		local -x GDK_BACKEND=x11
	fi

	${virtx_cmd} cmake_src_compile || die
}
