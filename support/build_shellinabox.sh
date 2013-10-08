#!/bin/bash
#
# Requires 'vulcan' to be installed and a build server created.
# https://devcenter.heroku.com/articles/buildpack-binaries
#
# Requires http://aws.amazon.com/cli/ to be installed & configured 
# Requires the S3 buckect to already be created - ie, aws s3 ls s3://dest-bucket-name should work


SHELLINABOX_VERSION=2.14
S3_BUCKET=ci-labs-buildpack-downloads
S3_KEY_PREFIX=shellinabox

SHELLINABOX_SOURCE_URL=https://shellinabox.googlecode.com/files/shellinabox-${SHELLINABOX_VERSION}.tar.gz 

temp_dir=$(mktemp -d /tmp/vulcan_shellinabox.XXXXXXXXXX)

cleanup() {
  echo "-----> Cleaning up $temp_dir"
  cd /
  rm -rf "$temp_dir"
}
trap cleanup EXIT

SCRIPT_DIR=$(cd $(dirname $0); pwd)
BUILD_OUTPUT=shellinabox-${SHELLINABOX_VERSION}.tar.gz

cd $temp_dir
echo "-----> Temp dir: $temp_dir"

echo "-----> Downloading $SHELLINABOX_SOURCE_URL"
curl $SHELLINABOX_SOURCE_URL | tar xf -

echo "-----> Patching for Cloud Foundry environment"
patch -p0 < $SCRIPT_DIR/shellinabox_cloudfoundry.patch

echo "-----> Building using vulcan"

vulcan build -o ${BUILD_OUTPUT} -s shellinabox-${SHELLINABOX_VERSION} -v -p /tmp/shellinabox -c "./configure --prefix=/tmp/shellinabox && make && make install"

echo "-----> Build at: ${BUILD_OUTPUT}"

echo "-----> Uploading build to: ${S3_BUCKET}"
aws s3 cp ${BUILD_OUTPUT} s3://${S3_BUCKET}/${S3_KEY_PREFIX}/${BUILD_OUTPUT}
echo "-----> s3://${S3_BUCKET}/${S3_KEY_PREFIX} now contains:"
aws s3 ls s3://${S3_BUCKET}/${S3_KEY_PREFIX}
echo "-----> Setting ACL to allow anonymous downloads "
aws s3api put-object-acl --bucket ${S3_BUCKET} --key ${S3_KEY_PREFIX}/${BUILD_OUTPUT} --acl public-read
echo "-----> Download url: http://${S3_BUCKET}.s3.amazonaws.com/${S3_KEY_PREFIX}/${BUILD_OUTPUT}"