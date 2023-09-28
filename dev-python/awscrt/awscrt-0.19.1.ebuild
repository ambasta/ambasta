# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1 pypi

DESCRIPTION=""
HOMEPAGE="
	https://github.com/awslabs/aws-crt-python
	https://pypi.org/project/awscrt/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
"
BDEPEND="
	test? (
		dev-python/boto3
		dev-python/pytest
		dev-python/websockets
	)"

distutils_enable_tests pytest
