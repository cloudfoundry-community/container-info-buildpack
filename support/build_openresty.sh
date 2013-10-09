#!/bin/bash
#
# Requires 'vulcan' to be installed and a build server created.
# https://devcenter.heroku.com/articles/buildpack-binaries
#
# Requires http://aws.amazon.com/cli/ to be installed & configured 
# Requires the S3 buckect to already be created - ie, aws s3 ls s3://dest-bucket-name should work

OPENRESTY_VERSION="1.2.8.6"

base_dir=$(pwd)

SCRIPT_DIR=$(cd $(dirname $0); pwd)
BUILD_OUTPUT=openresty-${OPENRESTY_VERSION}.tar.gz

S3_BUCKET=ci-labs-buildpack-downloads
S3_KEY_PREFIX=openresty

temp_dir=$(mktemp -d /tmp/vulcan_openresty.XXXXXXXXXX)
openresty_tar="ngx_openresty-${OPENRESTY_VERSION}.tar.gz"
pcre_tar="pcre-8.33.tar.gz"

cleanup() {
  echo "-----> Cleaning up $temp_dir"
  cd /
  rm -rf "$temp_dir"
}
trap cleanup EXIT

cd $temp_dir
echo "-----> Temp dir: $temp_dir"

echo "$(tput setaf 2)Downloading openresty...$(tput sgr0)"
curl -L "http://openresty.org/download/$openresty_tar" | tar xf -
echo "$(tput setaf 2)Downloading pcre...$(tput sgr0)"
pushd $temp_dir/ngx_openresty-${OPENRESTY_VERSION}
curl -L "http://downloads.sourceforge.net/sourceforge/pcre/$pcre_tar" | tar xf -
popd

echo "-----> Building using vulcan"

echo "$(tput setaf 2)Building openresty...$(tput sgr0)"
vulcan build -o ${BUILD_OUTPUT} -s $temp_dir/ngx_openresty-${OPENRESTY_VERSION} -v -p /tmp/openresty -c "PATH=/sbin:\$PATH ./configure --with-pcre=pcre-8.33 --with-luajit --with-http_postgres_module --prefix=/app/vendor/openresty && make && make DESTDIR=/tmp/openresty install"

echo "-----> Build at: ${BUILD_OUTPUT}"

echo "-----> Uploading build to: ${S3_BUCKET}"
aws s3 cp ${BUILD_OUTPUT} s3://${S3_BUCKET}/${S3_KEY_PREFIX}/${BUILD_OUTPUT}
echo "-----> s3://${S3_BUCKET}/${S3_KEY_PREFIX} now contains:"
aws s3 ls s3://${S3_BUCKET}/${S3_KEY_PREFIX}
echo "-----> Setting ACL to allow anonymous downloads "
aws s3api put-object-acl --bucket ${S3_BUCKET} --key ${S3_KEY_PREFIX}/${BUILD_OUTPUT} --acl public-read
echo "-----> Download url: http://${S3_BUCKET}.s3.amazonaws.com/${S3_KEY_PREFIX}/${BUILD_OUTPUT}"

echo "$(tput setaf 2)Done!$(tput sgr0)"