# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://aws.amazon.com/sdk-for-cpp/"
SRC_URI="https://github.com/aws/${PN}/archive/${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

AWS_TARGETS="access-management acm acm-pca alexaforbusiness apigateway application-autoscaling appstream appsync athena autoscaling autoscaling-plans AWSMigrationHub batch budgets ce cloud9 clouddirectory cloudformation cloudfront cloudfront-integration-tests cloudhsm cloudhsmv2 cloudsearch cloudsearchdomain cloudtrail codebuild codecommit codedeploy codepipeline codestar cognito-identity cognitoidentity-integration-tests cognito-idp cognito-sync comprehend config connect core core-tests cur datapipeline dax devicefarm directconnect discovery dms ds dynamodb dynamodb-integration-tests dynamodbstreams ec2 ec2-integration-tests ecr ecs eks elasticache elasticbeanstalk elasticfilesystem elasticloadbalancing elasticloadbalancingv2 elasticmapreduce elastictranscoder email es events firehose fms gamelift glacier glue greengrass guardduty health iam identity-management identity-management-tests importexport inspector iot iot1click-devices iot1click-projects iotanalytics iot-data iot-jobs-data kinesis kinesisanalytics kinesisvideo kinesis-video-archived-media kinesis-video-media kms lambda lambda-integration-tests lex lex-models lightsail logs machinelearning macie marketplacecommerceanalytics marketplace-entitlement mediaconvert medialive mediapackage mediastore mediastore-data mediatailor meteringmarketplace mobile mobileanalytics monitoring mq mturk-requester neptune opsworks opsworkscm organizations pi pinpoint polly polly-sample pricing queues rds redshift redshift-integration-tests rekognition resource-groups resourcegroupstaggingapi route53 route53domains s3 s3-encryption s3-encryption-integration-tests s3-encryption-tests s3-integration-tests sagemaker sagemaker-runtime sdb secretsmanager serverlessrepo servicecatalog servicediscovery shield sms snowball sns sqs sqs-integration-tests ssm states storagegateway sts support swf text-to-speech text-to-speech-tests transcribe transfer transfer-tests translate waf waf-regional workdocs workmail workspaces xray"

for module in ${AWS_TARGETS}; do
	IUSE_AWS_TARGETS+=" aws_targets_${module}"
done
IUSE="static-libs ${IUSE_AWS_TARGETS}"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCPP_STANDARD=17
 		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_ONLY="${AWS_TARGETS// /;}"
	)
	cmake-utils_src_configure
}
