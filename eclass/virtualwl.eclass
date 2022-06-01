# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: virtualwl.eclass
# @MAINTAINER:
# amit.prakash.ambasta@gmail.com
# @AUTHOR:
# Amit Prakash Ambasta
# @SUPPORTED_EAPIS: 8
# @BLURB: This eclass can be used for packages that need a working wayland environment to build.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI} unsupported."
esac

if [[ ! ${_VIRTUALWL_ECLASS} ]]; then
_VIRTUALWL_ECLASS=1

# @ECLASS-VARIABLE: VIRTUALWL_REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Variable specifying the dependency on wayland.
# Possible special values are "always" and "manual", which specify
# the dependency to be set unconditionally or not at all.
# Any other value is taken as useflag desired to be in control of
# the dependency (eg. VIRTUALWL_REQUIRED="kde" will add the dependency
# into "kde? ( )" and add kde into IUSE.
: ${VIRTUALWL_REQUIRED:=test}

# @ECLASS-VARIABLE: VIRTUALWL_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Standard dependencies string that is automatically added to BDEPEND
# unless VIRTUALWL_REQUIRED is set to "manual".
readonly VIRTUALWL_DEPEND="
	gui-wm/sway
	sys-auth/seatd
"

case ${VIRTUALWL_REQUIRED} in
	manual)
		;;
	always)
		BDEPEND="${VIRTUALWL_DEPEND}"
		;;
	*)
		BDEPEND="${VIRTUALWL_REQUIRED}? ( ${VIRTUALWL_DEPEND} )"
		IUSE="${VIRTUALWL_REQUIRED}"
		[[ ${VIRTUALWL_REQUIRED} == "test" ]] &&
			RESTRICT+=" !test? ( test )"
		;;
esac

# @FUNCTION: virtwl
# @USAGE: <command> [command arguments]
# @DESCRIPTION:
# Start a new wayland session and run commands in it.
#
# IMPORTANT: This command is run nonfatal !!!
#
# This means we are checking for the return code and raise an exception if it
# isn't 0. So you need to make sure that all commands return a proper
# code and not just die. All eclass function used should support nonfatal
# calls properly.
#
# The rationale behind this is the tear down of the started wayland session. A
# straight die would leave a running session behind.
#
# Example:
#
# @CODE
# src_test() {
#     virtwl default
# }
# @CODE
#
# @CODE
# python_test() {
#     virtwl py.test --verbose
# }
# @CODE
#
# @CODE
# my_test() {
#   some_command
#   return $?
# }
#
# src_test() {
#	  virtwl my_test
# }
# @CODE
virtwl() {
	debug-print-function ${FUNCNAME} "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument. Missing command to run"

	local idx=0
	local retval=0
	local OLD_SANDBOX_ON="${SANDBOX_ON}"
	local SWAY DBUS WL_DISPLAY
	local swayargs="-d"
	local swayenv

	SWAY=$(type -p sway) || die
	DBUS=$(type -p dbus-launch) || die

	debug-print "${FUNCNAME}: running headless sway"

	einfo "Scanning for an open WAYLAND_DISPLAY to start wayland..."
	WL_DISPLAY=$(idx=1; while [[ -f /tmp/wayland-${idx}.lock ]] ; do ((idx++)); done; echo ${idx})
	debug-print "${FUNCNAME}: WL_DISPLAY=${WL_DISPLAY}"

	export WLR_BACKENDS=headless
	export XDG_RUNTIME_DIR=/tmp
	export XDG_SESSION_TYPE=wayland
	export WLR_RENDERER=pixman
	export WAYLAND_DISPLAY="wayland-${WL_DISPLAY}"

	swayenv+="WLR_BACKENDS=headless"
	swayenv+=" WLR_RENDERER=pixman"
	swayenv+=" XDG_RUNTIME_DIR=${T}"
	swayenv+=" XDG_SESSION_TYPE=wayland"

	# We really do not want SANDBOX enabled here
	export SANDBOX_ON="0"

	debug-print "${FUNCNAME}: ${DBUS} ${SWAY} ${swayargs}"
	${DBUS} ${SWAY} ${swayargs} &>/dev/null &
	sleep 5

	local start=${WL_DISPLAY}
	while [[ ! -f /tmp/wayland-${WL_DISPLAY}.lock ]]; do
		einfo "No wayland session found at /tmp/wayland-${WL_DISPLAY}.lock"
		# Stop trying after 5 tries
		if ((WL_DISPLAY - start > 5)) ; then
			eerror "'${swayenv} WAYLAND_DISPLAY=\"wayland-${WL_DISPLAY}\" ${DBUS} ${SWAY} ${swayargs}' returns:"
			echo
			${DBUS} ${SWAY} ${swayargs} &>/dev/null &
			echo
			eerror "If possible, correct the above error and try your emerge again."
			die "Unable to start sway"
		fi
			((WL_DISPLAY++))
		export WAYLAND_DISPLAY="wayland-${WL_DISPLAY}"
		debug-print "${FUNCNAME}: ${DBUS} :${SWAY} ${swayargs}"
		${DBUS} ${SWAY} ${swayargs} &>/dev/null &
		sleep 5
	done

	# Now enable SANDBOX again if needed.
	export SANDBOX_ON="${OLD_SANDBOX_ON}"

	einfo "Starting sway on \$WAYLAND_DISPLAY=${WAYLAND_DISPLAY} ..."

	# Do not break on error, but setup $retval, as we need
	# to kill the started wayland session.
	debug-print "${FUNCNAME}: $@"
	nonfatal "$@"
	retval=$?

	# Now kill sway
	fuser -k -TERM /tmp/wayland-${WL_DISPLAY}.lock

	# die if our command failed
	[[ ${retval} -ne 0 ]] && die "Command '$@' failed with return code ${retval}"

	return 0 # always return 0, it can be altered by failed kill for sway
}

fi
