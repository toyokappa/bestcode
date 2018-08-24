if (typeof process.env.ENV === 'undefined') {
  console.error('You need to define $ENV for npm build.');
  process.exit(1);
}

const path = require('path');
const s3 = require('s3');

const __root    = path.resolve(__dirname, '../');
const buildPath = path.resolve(__root, 'public', process.env.ENV, 'assets');
const prefix    = process.env.ENV + "/assets/"

const accessKeyId     = process.env.S3_ACCESS_KEY;
const secretAccessKey = process.env.S3_SECRET_KEY;

const today = new Date();
const one_year_from_now = new Date(today.getFullYear() + 1, today.getMonth() + 1, today.getDate());

// クライアント作成
var client = s3.createClient({
  maxAsyncS3: 20,     // this is the default
  s3RetryCount: 3,    // this is the default
  s3RetryDelay: 1000, // this is the default
  multipartUploadThreshold: 20971520, // this is the default (20 MB)
  multipartUploadSize: 15728640, // this is the default (15 MB)
  s3Options: {
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey,
    region: "ap-northeast-1"
    // endpoint: 's3.yourdomain.com',
    // sslEnabled: false
    // any other options are passed to new AWS.S3()
    // See: http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Config.html#constructor-property
  },
});

// ビルドディレクトリを丸ごと同期する
var params = {
  localDir: buildPath,
  deleteRemoved: true, // default false, whether to remove s3 objects
                       // that have no corresponding local file.

  s3Params: {
    Bucket: "bestcode-app",
    Prefix: prefix,
    ACL: "public-read",
    CacheControl: "max-age=315576000",
    Expires: one_year_from_now
    // other options supported by putObject, except Body and ContentLength.
    // See: http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/S3.html#putObject-property
  },
};
var uploader = client.uploadDir(params);
uploader.on('error', function(err) {
  console.error("[ERROR] unable to sync:", err.stack);
});
uploader.on('end', function() {
  console.log("[INFO] done uploading");
});
