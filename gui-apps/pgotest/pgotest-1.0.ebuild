# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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

create_wayland_user() {
	useradd -m -G video waylanduser || die "Failed to create waylanduser"
}

delete_wayland_user() {
	userdel -r waylanduser || ewarn "Failed to delete waylanduser"
}

virtwl() {
	debug-print-function ${FUNCNAME} "$@"

	create_wayland_user

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"
	[[ -n $XDG_RUNTIME_DIR ]] || die "${FUNCNAME} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"
	sway -h >/dev/null || die 'sway -h failed'

	addpredict /dev/dri

	local user_runtime_dir="/run/user/$(id -u waylanduser)"
	mkdir -p "${user_runtime_dir}"
	chown -R waylanduser:video "${user_runtime_dir}"
	chmod 0700 "${user_runtime_dir}"

	su -l waylanduser -s /bin/bash -c "XDG_RUNTIME_DIR='${user_runtime_dir}' WAYLAND_DISPLAY=wayland-0 sway -C /dev/null -d" &
	local sway_pid=$!
	sleep 3 # Give sway some time to start up

	su -l waylanduser -s /bin/bash -c "XDG_RUNTIME_DIR='${user_runtime_dir}' WAYLAND_DISPLAY=wayland-0 $@" || die

	kill "${sway_pid}"
	wait "${swap_pid}" || ewarn "Failed to terminate sway gracefully"

	delete_wayland_user

	# Add the required video group for the user to access DRI devices
	# addpredict /dev/dri
	# local VIRTWL VIRTWL_PID
	# coproc VIRTWL { WLR_RENDERER=vulkan exec sway -c /dev/null -d -E 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; }
	# local -x WAYLAND_DISPLAY
	# read WAYLAND_DISPLAY <&${VIRTWL[0]}

	# debug-print "${FUNCNAME}: $@"
	# "$@"

	# [[ -n $VIRTWL_PID ]] || die "sway exited unexpectedly"
	# exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-
}

src_compile() {
	local virtx_cmd=

	if use pgo; then
		gnome2_environment_reset

		if ! use X; then
			virtx_cmd=vritwl
		else
			virtx_cmd=virtx
		fi
	fi

	if ! use X; then
		local -x GDK_BACKEND=wayland
	else
		local -x GDK_BACKEND=x11
	fi

	# Create the wayland user
	create_wayland_user

	# Use the new user to run the wayland session
	export XDG_RUNTIME_DIR="/run/user/$(id -u waylanduser)"
	mkdir -p "${XDG_RUNTIME_DIR}"
	chown -R waylanduser:video "${XDG_RUNTIME_DIR}"
	chown 0700 "${XDG_RUNTIME_DIR}"

	# Run the command using su to switch to the wayland user
	su -l waylanduser -s /bin/bash -c "${virtx_cmd} cmake_src_compile" || die

	# Delete the wayland user
	delete_wayland_user
}