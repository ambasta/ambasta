import os

libraries = [
    "aws-cpp-sdk-access-management", "aws-cpp-sdk-acm", 
    "aws-cpp-sdk-apigateway", "aws-cpp-sdk-application-autoscaling", 
    "aws-cpp-sdk-autoscaling", "aws-cpp-sdk-cloudformation", 
    "aws-cpp-sdk-cloudfront", "aws-cpp-sdk-cloudhsm", 
    "aws-cpp-sdk-cloudsearch", "aws-cpp-sdk-cloudsearchdomain", 
    "aws-cpp-sdk-cloudtrail", "aws-cpp-sdk-codecommit", 
    "aws-cpp-sdk-codedeploy", "aws-cpp-sdk-codepipeline", 
    "aws-cpp-sdk-cognito-identity", 
    "aws-cpp-sdk-cognito-idp", "aws-cpp-sdk-cognito-sync", 
    "aws-cpp-sdk-config", "aws-cpp-sdk-core", "aws-cpp-sdk-datapipeline", 
    "aws-cpp-sdk-devicefarm", "aws-cpp-sdk-directconnect", 
    "aws-cpp-sdk-dms", "aws-cpp-sdk-ds", "aws-cpp-sdk-dynamodb", 
    "aws-cpp-sdk-ec2", "aws-cpp-sdk-ecr", "aws-cpp-sdk-ecs", 
    "aws-cpp-sdk-elasticache", "aws-cpp-sdk-elasticbeanstalk", 
    "aws-cpp-sdk-elasticfilesystem", "aws-cpp-sdk-elasticloadbalancing", 
    "aws-cpp-sdk-elasticloadbalancingv2", "aws-cpp-sdk-elasticmapreduce", 
    "aws-cpp-sdk-elastictranscoder", "aws-cpp-sdk-email", "aws-cpp-sdk-es", 
    "aws-cpp-sdk-events", "aws-cpp-sdk-firehose", "aws-cpp-sdk-gamelift", 
    "aws-cpp-sdk-glacier", "aws-cpp-sdk-iam", 
    "aws-cpp-sdk-identity-management", "aws-cpp-sdk-importexport", 
    "aws-cpp-sdk-inspector", "aws-cpp-sdk-iot", "aws-cpp-sdk-kinesis", 
    "aws-cpp-sdk-kinesisanalytics", "aws-cpp-sdk-kms", "aws-cpp-sdk-lambda", 
    "aws-cpp-sdk-logs", "aws-cpp-sdk-machinelearning", 
    "aws-cpp-sdk-marketplacecommerceanalytics", 
    "aws-cpp-sdk-meteringmarketplace", "aws-cpp-sdk-mobileanalytics", 
    "aws-cpp-sdk-monitoring", "aws-cpp-sdk-opsworks", "aws-cpp-sdk-queues", 
    "aws-cpp-sdk-rds", "aws-cpp-sdk-redshift", "aws-cpp-sdk-route53", 
    "aws-cpp-sdk-route53domains", "aws-cpp-sdk-s3", "aws-cpp-sdk-sdb", 
    "aws-cpp-sdk-servicecatalog", "aws-cpp-sdk-snowball", "aws-cpp-sdk-sns", 
    "aws-cpp-sdk-sqs", "aws-cpp-sdk-ssm", "aws-cpp-sdk-storagegateway", 
    "aws-cpp-sdk-sts", "aws-cpp-sdk-support", "aws-cpp-sdk-swf", 
    "aws-cpp-sdk-transfer", "aws-cpp-sdk-waf", "aws-cpp-sdk-workspaces"]


ebuild_format = '''# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic multilib versionator

DESCRIPTION="C++ interface for Amazon {pname}"
HOMEPAGE="https://github.com/aws/aws-sdk-cpp"

KEYWORDS="~amd64 ~x86"

LICENSE="Apache-2.0"
IUSE="-static-libs -custom-memory-management +http"
SLOT=0
DEPEND=">=dev-cpp/aws-cpp-sdk-core-${{PV}}"

if [[ ${{PV}} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/ambasta/aws-sdk-cpp.git"
    EGIT_CLONE_TYPE=single
else
    SRC_URI="https://github.com/aws/aws-sdk-cpp/archive/${{PV}}.tar.gz -> aws-cpp-sdk-${{PV}}.tar.gz"
    S="${{WORKDIR}}/aws-sdk-cpp-${{PV}}"
fi

src_configure() {{
    local mycmakeargs=(
        -DCUSTOM_MEMORY_MANAGEMENT=$(usex static-libs 0 1)
        -DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
        -DNO_HTTP_CLIENT=$(usex http ON OFF)
        -DCPP_STANDARD="17"
        -DENABLE_TESTING=OFF
        -DBUILD_ONLY="{pname}"
        -DLIBDIR=/usr/$(get_libdir)
    )
    cmake-utils_src_configure
}}'''


for library in libraries:
    if not os.path.exists(library):
        os.makedirs(library)

    f = open('{}/{}-9999.ebuild'.format(library, library), 'w')
    pname = library.split('aws-cpp-sdk-')[1]
    f.writelines(ebuild_format.format(pname=pname))
    f.close()