# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic multilib versionator

DESCRIPTION="C++ interface for Amazon core"
HOMEPAGE="https://github.com/aws/aws-sdk-cpp"

KEYWORDS="~amd64 ~x86"

LICENSE="Apache-2.0"
IUSE="-static-libs -custom-memory-management +http"
SLOT=0
DEPEND=">=dev-cpp/aws-cpp-sdk-core-${PV}"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/ambasta/aws-sdk-cpp.git"
    EGIT_CLONE_TYPE=single
else
    SRC_URI="https://github.com/aws/aws-sdk-cpp/archive/${PV}.tar.gz -> aws-cpp-sdk-${PV}.tar.gz"
    S="${WORKDIR}/aws-sdk-cpp-${PV}"
fi

src_configure() {
    local mycmakeargs=(
        -DCUSTOM_MEMORY_MANAGEMENT=$(usex static-libs 0 1)
        -DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
        -DNO_HTTP_CLIENT=$(usex http ON OFF)
        -DCPP_STANDARD="17"
        -DENABLE_TESTING=OFF
        -DBUILD_ONLY="core"
        -DLIBDIR=/usr/$(get_libdir)
    )
    cmake-utils_src_configure
}