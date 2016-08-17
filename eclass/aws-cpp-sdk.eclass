inherit cmake-utils multilib versionator

IUSE="-static-libs -custom-memory-management +http"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aws/aws-sdk-cpp.git"
else
	SRC_URI="https://github.com/aws/aws-sdk-cpp/archive/${PV}.tar.gz -> aws-cpp-sdk-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

if [[ ${PV} == 9999 ]]; then
EGIT_CLONE_TYPE=single
else
S="${WORKDIR}/aws-sdk-cpp-${PV}"
fi

# @FUNCTION: aws-cpp-sdk_src_prepare
# @USAGE
# @DESCRIPTION:
# Removes all directories except for the library selected for build
aws-cpp-sdk_src_prepare() {
	for subdir in `dir ${S}/`; do
		if [[ -d ${subdir} ]]; then
			if [[ ${subdir} == ${PN} ]] || [[ ${subdir} == "${PN}-tests" ]]; then
				continue
			else
				rm -fR ${subdir} || die
			fi
		fi
	done
	cmake-utils_src_prepare
}

# @FUNCTION: aws-cpp-sdk_src_configure
# @USAGE
# @DESCRIPTION:
# Configure cmake with right arguments
aws-cpp-sdk_src_configure() {
	_tmp_last_index=$(($(get_last_version_component_index ${PN})+1))
	_tmp_suffix=$(get_version_component_range ${_tmp_last_index} ${PN})

	local mycmakeargs=(
		-DCUSTOM_MEMORY_MANAGEMENT=$(usex static-libs 0 1)
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DNO_HTTP_CLIENT=$(usex http ON OFF)
		-DCPP_STANDARD="17"
		-DENABLE_TESTING=OFF
		-DBUILD_ONLY="${_tmp_suffix}"
		-DLIBDIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}

EXPORT_FUNCTIONS src_configure
