# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION=" Google's Operations Research tools"
HOMEPAGE="https://developers.google.com/optimization"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE='doc coinor cplex examples express glop glpk java parser python samples +scip static-libs'

DEPEND="coinor? (
		sci-libs/coinor-utils
		sci-libs/coinor-osi
		sci-libs/coinor-clp
		sci-libs/coinor-cgl
		sci-libs/coinor-cbc
	)
	glpk? ( sci-mathematics/glpk )
	scip? ( sci-libs/scip )
	python? ( dev-python/pybind11 )"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/Support-for-USE_PDLP-C-23-and-Werror-changes.patch"
)

# S="${WORKDIR}/${PN}-${PV//./}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CXX=ON
		-DBUILD_DEPS=OFF
		-DBUILD_ZLIB=OFF
		-DBUILD_absl=OFF
		-DBUILD_GLOP=OFF
		-DBUILD_FLATZINC=OFF
		-DBUILD_Protobuf=OFF
		-DBUILD_re2=OFF
		-DBUILD_CoinUtils=OFF
		-DBUILD_Osi=OFF
		-DBUILD_Clp=OFF
		-DBUILD_Cgl=OFF
		-DBUILD_Cbc=OFF
		-DBUILD_GLPK=OFF
		-DBUILD_HIGHS=OFF
		-DBUILD_Eigen3=OFF
		-DBUILD_SCIP=OFF
		-DBUILD_DOTNET=OFF
		-DBUILD_pybind11=OFF
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DBUILD_PYTHON=$(usex python)
		-DBUILD_JAVA=$(usex java)
		-DBUILD_LP_PARSER=$(usex parser)
		-DBUILD_SAMPLES=$(usex samples)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_DOC=$(usex doc)
		-DUSE_COINOR=$(usex coinor)
		-DUSE_GLPK=$(usex glpk)
		-DUSE_HIGHS=OFF
		-DUSE_PDLP=OFF
		-DUSE_SCIP=$(usex scip)
		-DUSE_CPLEX=$(usex cplex)
		-DUSE_XPRESS=$(usex express)
	)

	#if use pdlp; then
	#	mycmakeargs+=( -DBUILD_PDLP=OFF )
	#fi

	if use python; then
		mycmakeargs+=( -DBUILD_VENV=OFF )
	fi

	cmake_src_configure
}
