# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://aws.amazon.com/sdk-for-cpp/"
SRC_URI="https://github.com/aws/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULES=(
	"aws_access-management aws_acm aws_acm-pca aws_alexaforbusiness"
	"aws_apigateway aws_application-autoscaling aws_appstream aws_appsync"
	"aws_athena aws_autoscaling aws_autoscaling-plans aws_AWSMigrationHub"
	"aws_batch aws_budgets aws_ce aws_cloud9 aws_clouddirectory"
	"aws_cloudformation aws_cloudfront aws_cloudhsm aws_cloudhsmv2"
	"aws_cloudsearch aws_cloudsearchdomain aws_cloudtrail aws_codebuild"
	"aws_codecommit aws_codedeploy aws_codepipeline aws_codestar"
	"aws_cognito-identity aws_cognito-idp aws_cognito-sync aws_comprehend"
	"aws_config aws_connect aws_cur aws_datapipeline aws_dax aws_devicefarm"
	"aws_directconnect aws_discovery aws_dms aws_ds aws_dynamodb"
	"aws_dynamodbstreams aws_ec2 aws_ecr aws_ecs aws_eks aws_elasticache"
	"aws_elasticbeanstalk aws_elasticfilesystem aws_elasticloadbalancing"
	"aws_elasticloadbalancingv2 aws_elasticmapreduce aws_elastictranscoder"
	"aws_email aws_es aws_events aws_firehose aws_fms aws_gamelift aws_glacier"
	"aws_glue aws_greengrass aws_guardduty aws_health aws_iam"
	"aws_identity-management aws_importexport aws_inspector aws_iot"
	"aws_iot1click-devices aws_iot1click-projects aws_iotanalytics aws_iot-data"
	"aws_iot-jobs-data aws_kinesis aws_kinesisanalytics aws_kinesisvideo"
	"aws_kinesis-video-archived-media aws_kinesis-video-media aws_kms"
	"aws_lambda aws_lex aws_lex-models aws_lightsail aws_logs"
	"aws_machinelearning aws_macie aws_marketplacecommerceanalytics"
	"aws_marketplace-entitlement aws_mediaconvert aws_medialive"
	"aws_mediapackage aws_mediastore aws_mediastore-data aws_mediatailor"
	"aws_meteringmarketplace aws_mobile aws_mobileanalytics aws_monitoring"
	"aws_mq aws_mturk-requester aws_neptune aws_opsworks aws_opsworkscm"
	"aws_organizations aws_pi aws_pinpoint aws_polly aws_pricing aws_queues"
	"aws_rds aws_redshift aws_rekognition aws_resource-groups"
	"aws_resourcegroupstaggingapi aws_route53 aws_route53domains aws_s3"
	"aws_s3-encryption aws_sagemaker aws_sagemaker-runtime aws_sdb"
	"aws_secretsmanager aws_serverlessrepo aws_servicecatalog"
	"aws_servicediscovery aws_shield aws_sms aws_snowball aws_sns aws_sqs aws_ssm"
	"aws_states aws_storagegateway aws_sts aws_support aws_swf aws_text-to-speech"
	"aws_transcribe aws_transfer aws_translate aws_waf aws_waf-regional"
	"aws_workdocs aws_workmail aws_workspaces aws_xray"
)

IUSE="static-libs test"

for module in ${MODULES}; do
	IUSE="${IUSE} ${module}"
done
unset module

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local mybuildtargets="core"

	for module in ${MODULES}; do
		if use ${module}; then
			mybuildtargets="${mybuildtargets};${module#aws_}"
		fi
	done

	local mycmakeargs=(
		-DCPP_STANDARD=17
		-DENABLE_TESTING=$(usex test)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_ONLY="${mybuildtargets}"
	)
	cmake-utils_src_configure
}
