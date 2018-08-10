#!/bin/bash
set -ex

echo Setup Webpack
yarn cache clean
yarn install
yarn run start
