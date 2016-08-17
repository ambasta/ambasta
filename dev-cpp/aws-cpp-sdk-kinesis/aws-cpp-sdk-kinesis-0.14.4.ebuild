# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit aws-cpp-sdk

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://github.com/aws/aws-sdk-cpp"


LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT=0
DEPEND=""

PATCHES=("${FILESDIR}/cmake_gnu_fixes.patch")
