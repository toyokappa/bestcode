#! /bin/bash

# エラーで処理中断
set -ex

APP_NAME=bestcode
EB_BUCKET=elasticbeanstalk-ap-northeast-1-195500977316
NAMESPACE=toyokappa
CONTAINER_REGISTRY=195500977316.dkr.ecr.ap-northeast-1.amazonaws.com
SHA1=$1
ENV=$2
BUILD_NO=$3

if [ -n "$ENV" -a "$ENV" = "production" ]; then
  RAILS_MEMORY=600
  SIDEKIQ_MEMORY=200
  NGINX_MEMORY=128
  NGINX_TAG=latest
elif [ -n "$ENV" -a "$ENV" = "staging" ]; then
  RAILS_MEMORY=600
  SIDEKIQ_MEMORY=200
  NGINX_MEMORY=128
  NGINX_TAG=release
fi

DOCKERRUN_FILE=Dockerrun.aws.json
BUNDLE=${SHA1}-${APP_NAME}-${ENV}-bundle.zip
VERSION_LABEL=${APP_NAME}-${ENV}-${SHA1}-${BUILD_NO}

sed "s/<TAG>/${SHA1}/" < Dockerrun.aws.json.template > ${DOCKERRUN_FILE}
sed -i -e "s/<APP_NAME>/${APP_NAME}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<NAMESPACE>/${NAMESPACE}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<RAILS_ENV>/${ENV}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<CONTAINER_REGISTRY>/${CONTAINER_REGISTRY}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<RAILS_MEMORY>/${RAILS_MEMORY}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<SIDEKIQ_MEMORY>/${SIDEKIQ_MEMORY}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<NGINX_MEMORY>/${NGINX_MEMORY}/g" ${DOCKERRUN_FILE}
sed -i -e "s/<NGINX_TAG>/${NGINX_TAG}/g" ${DOCKERRUN_FILE}

zip ${BUNDLE} -r ${DOCKERRUN_FILE} .ebextensions # <-- ここでSource Bundleをつくっています。
aws s3 cp ${BUNDLE} s3://${EB_BUCKET}/${BUNDLE}
aws elasticbeanstalk create-application-version --region ap-northeast-1 --application-name ${APP_NAME} \
  --version-label ${VERSION_LABEL} --source-bundle S3Bucket=${EB_BUCKET},S3Key=${BUNDLE}

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --region ap-northeast-1 --environment-name ${APP_NAME}-${ENV} \
    --version-label ${VERSION_LABEL}
