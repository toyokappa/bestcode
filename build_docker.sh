#! /bin/bash

# エラーで処理中断
set -ex

export APP_NAME=bestcode
export EB_BUCKET=elasticbeanstalk-ap-northeast-1-195500977316
export NAMESPACE=toyokappa
export CONTAINER_REGISTRY=195500977316.dkr.ecr.ap-northeast-1.amazonaws.com
export SHA1=$1
export ENV=$2

if [ -n "$ENV" -a "$ENV" = "production" ]; then
  NGINX_TAG=latest
elif [ -n "$ENV" -a "$ENV" = "staging" ]; then
  NGINX_TAG=release
fi
export NGINX_TAG

# bundle install
BUNDLE_CACHE_PATH=~/caches/bundle
bundle install --path=${BUNDLE_CACHE_PATH}

# webpackのbuild
ENV=${ENV} yarn run build:app

$(aws ecr get-login --region ap-northeast-1)

# Rails作成
build_rails_image() {
  echo start rails container build
  local rails_docker_cache=~/caches/docker/${APP_NAME}-rails_${ENV}.tar
  local rails_image_name=${CONTAINER_REGISTRY}/${NAMESPACE}/${APP_NAME}-rails:${ENV}_${SHA1}

  if [[ -e ${rails_docker_cache} ]]; then
    docker load -i ${rails_docker_cache}
  fi

  docker build --rm=false -t ${rails_image_name} .
  mkdir -p ~/caches/docker
  docker save -o ${rails_docker_cache} $(docker history ${rails_image_name} -q | grep -v missing)
  time docker push ${rails_image_name}
  echo end rails container build
}
export -f build_rails_image

build_nginx_image() {
  echo start nginx container build
  local nginx_docker_cache=~/caches/docker/${APP_NAME}-nginx_${ENV}.tar
  local nginx_image_name=${CONTAINER_REGISTRY}/${NAMESPACE}/${APP_NAME}-nginx:${NGINX_TAG}

  if [[ -e ${nginx_docker_cache} ]]; then
    docker load -i ${nginx_docker_cache}
  fi

  docker build --rm=false -t ${nginx_image_name} ./containers/nginx
  mkdir -p ~/caches/docker
  docker save -o ${nginx_docker_cache} $(docker history ${nginx_image_name} -q | grep -v missing)
  time docker push ${nginx_image_name}
  echo end nginx container build
}
export -f build_nginx_image

# 並列にビルドを行う
cat << EOS | xargs -P 2 -Icommand bash -c "set -ex; \command"
build_rails_image
build_nginx_image
EOS
