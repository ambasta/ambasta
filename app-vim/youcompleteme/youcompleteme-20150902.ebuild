# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit multilib python-single-r1 cmake-utils vim-plugin

KEYWORDS="~amd64 ~x86"
SRC_URI="
	https://github.com/Valloric/YouCompleteMe/archive/a2808ee3ff7e8f4e90f6157f062c2aac6057c087.zip -> youcompleteme-a2808ee3ff7e8f4e90f6157f062c2aac6057c087.zip
	https://github.com/Valloric/ycmd/archive/b46b8f09e33ccb6c70dfd02bba879c0b77fff4d5.zip -> ycmd-b46b8f09e33ccb6c70dfd02bba879c0b77fff4d5.zip
	https://github.com/ross/requests-futures/archive/98712e7d0f6be2a090b6fda2a925f85e63656b58.zip -> requests-futures-98712e7d0f6be2a090b6fda2a925f85e63656b58.zip
	https://github.com/OmniSharp/omnisharp-server/archive/e1902915c6790bcec00b8d551199c8a3537d33c9.zip -> omnisharp-server-e1902915c6790bcec00b8d551199c8a3537d33c9.zip
	https://github.com/slezica/python-frozendict/archive/b27053e4d11f5891319fd29eda561c130ba3112a.zip -> python-frozendict-b27053e4d11f5891319fd29eda561c130ba3112a.zip
	https://github.com/nsf/gocode/archive/110f355028eeaf1987863e9921eda6692a4a9d7c.zip -> gocode-110f355028eeaf1987863e9921eda6692a4a9d7c.zip
"

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="http://valloric.github.io/YouCompleteMe/"

LICENSE="GPL-3"
IUSE="+clang test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	clang? ( >=sys-devel/clang-3.3 )
	dev-libs/boost[python,threads,${PYTHON_USEDEP}]
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dev-cpp/gmock
	dev-cpp/gtest
	dev-python/bottle[${PYTHON_USEDEP}]
	dev-python/futures[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/sh[${PYTHON_USEDEP}]
	dev-python/waitress[${PYTHON_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		dev-cpp/gmock
		dev-cpp/gtest
	)
"

S="${WORKDIR}/YouCompleteMe-a2808ee3ff7e8f4e90f6157f062c2aac6057c087"
CMAKE_IN_SOURCE_BUILD=1
CMAKE_USE_DIR=${S}/third_party/ycmd/cpp

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	for third_party_module in ycmd requests pythonfutures requests-futures; do
		rm -r "${S}"/third_party/${third_party_module} || die "Failed to remove third party module ${third_party_module}"
	done
	mv ${WORKDIR}/ycmd-b46b8f09e33ccb6c70dfd02bba879c0b77fff4d5 ${S}/third_party/ycmd
	mv ${WORKDIR}/omnisharp-server-e1902915c6790bcec00b8d551199c8a3537d33c9 ${S}/third_party/ycmd/third_party/omnisharp-server
	mv ${WORKDIR}/python-frozendict-b27053e4d11f5891319fd29eda561c130ba3112a ${S}/third_party/ycmd/third_party/python-frozendict
	mv ${WORKDIR}/gocode-110f355028eeaf1987863e9921eda6692a4a9d7c ${S}/third_party/ycmd/third_party/gocode
	mv ${WORKDIR}/requests-futures-98712e7d0f6be2a090b6fda2a925f85e63656b58 ${S}/third_party/request-futures
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use clang CLANG_COMPLETER)
		$(cmake-utils_use_use clang SYSTEM_LIBCLANG)
		-DUSE_SYSTEM_BOOST=ON
		-DUSE_SYSTEM_GMOCK=ON
	)
	cmake-utils_src_configure
}

src_test() {
	cd "${S}/third_party/ycmd/cpp/ycm/tests"
	LD_LIBRARY_PATH="${EROOT}"/usr/$(get_libdir)/llvm \
		./ycm_core_tests || die

	cd "${S}"/python/ycm

	local dirs=( "${S}"/third_party/*/ "${S}"/third_party/ycmd/third_party/*/ )
	local -x PYTHONPATH=${PYTHONPATH}:$(IFS=:; echo "${dirs[*]}")

	nosetests || die
}

src_install() {
	dodoc *.md third_party/ycmd/*.md
	rm -r *.md *.sh COPYING.txt third_party/ycmd/cpp || die
	rm -r third_party/ycmd/{*.md,*.sh} || die
	find python -name *test* -exec rm -rf {} + || die
	find "${S}" -name '.git*' -exec rm -rf {} + || die
	rm third_party/ycmd/libclang.so || die

	vim-plugin_src_install

	python_optimize "${ED}"
	python_fix_shebang "${ED}"
}
