inherit cmake-utils versionator

IUSE="-static-libs -custom-memory-management +http"

if [[ ${PV} == 9999 ]]; then
EGIT_CLONE_TYPE=single
else
S="${WORKDIR}/aws-sdk-cpp-${PV}/${PN}"
fi

# @FUNCTION: aws-cpp-sdk_src_prepare
# @USAGE
# @DESCRIPTION:
# Removes all directories except for the library selected for build
# aws-cpp-sdk_src_prepare() {
# 	for subdir in `dir ${S}/`; do
# 		if [[ -d ${subdir} ]]; then
# 			if [[ ${subdir} == ${PN} ]]; then
# 				continue
# 			else
# 				rm -fR ${subdir} || die
# 			fi
# 		fi
# 	done
# 	cmake-utils_src_prepare
# }

# @FUNCTION: aws-cpp-sdk_src_configure
# @USAGE
# @DESCRIPTION:
# Configure cmake with right arguments
aws-cpp-sdk_src_configure() {
	_tmp_last_index=$(($(get_last_version_component_index ${PN})+1))
	_tmp_suffix=$(get_version_component_range ${_tmp_last_index} ${PN})
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCUSTOM_MEMORY_MANAGEMENT=$(usex custom-memory-management 0 1)
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DNO_HTTP_CLIENT=$(usex http ON OFF)
		-DCPP_STANDARD="17"
		-DBUILD_ONLY="${_tmp_suffix}"
	)
	cmake-utils_src_configure
}

EXPORT_FUNCTIONS src_configure
