# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit aws-cpp-sdk

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://github.com/aws/aws-sdk-cpp"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aws/aws-sdk-cpp.git"
else
	SRC_URI="https://github.com/aws/aws-sdk-cpp/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT=0

KEYWORDS="~amd64 ~x86"
DEPEND=""
