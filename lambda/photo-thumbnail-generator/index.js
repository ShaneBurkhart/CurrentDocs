var async = require('async');
var path = require('path');
var AWS = require('aws-sdk');
var gm = require('gm').subClass({
    imageMagick: true
});
var util = require('util');
var s3 = new AWS.S3();

// Should match accept function for upload_photos modal
var VALID_EXT = ['png', 'jpg', 'jpeg', 'tiff', 'gif'];
var PHOTO_SIZES = [
  { name: 'thumbnail', max_width: 100, max_height: 100 },
  { name: 'large', max_width: 1600, max_height: 1200 },
];

var getS3Object = function (bucket, key, callback) {
  s3.getObject({
    Bucket: bucket,
    Key: key,
  }, callback);
};

var putS3Object = function (bucket, key, buffer, contentType, callback) {
  s3.putObject({
    Bucket: bucket,
    Key: key,
    Body: buffer,
    ContentType: contentType,
    ACL: 'public-read',
  }, callback);
};

var createResizeTask = function (bucket, key, extension, photoSize) {
  return function (resizeCallback) {
    var keyParts = key.split("/");

    // Change "directory" from photos/ to photos-<name>/
    keyParts.splice(0, 1, "photos-" + photoSize.name);
    var destKey = keyParts.join("/");

    async.waterfall([
      function download(next) {
        // Download the image from S3 into a buffer.
        getS3Object(bucket, key, next);
      },

      function tranform(response, transformCallback) {
        gm(response.Body).size(function(err, size) {
          if (err) return transformCallback(err);

          var scalingFactor = Math.min(
            photoSize.max_width / size.width,
            photoSize.max_height / size.height
          );

          var width = scalingFactor * size.width;
          var height = scalingFactor * size.height;

          // Infer the scaling factor to avoid stretching the image unnaturally.
          // Transform the image buffer in memory.
          this.resize(width, height)
            .toBuffer(extension, function(err, buffer) {
              if (err) return transformCallback(err);

              // Stream the transformed image to a different S3 bucket.
              transformCallback(null, response.ContentType, buffer);
            });
        });
      },

      function upload(contentType, data, next) {
        // Stream the transformed image to a different S3 bucket.
        putS3Object(bucket, destKey, data, contentType, next);
      }],

      function (err) {
        if (err) {
          console.error(
            'Unable to resize ' + bucket + '/' + key +
            ' and upload to ' + bucket + '/' + destKey +
            ' due to an error: ' + err
          );
          return resizeCallback(err);
        }

        console.log(
          'Successfully resized ' + bucket + '/' + key +
          ' and uploaded to ' + bucket + '/' + destKey
        );
        resizeCallback();
      }
    );
  };
};

exports.handler = function (event, context, callback) {
  var bucket = event.Records[0].s3.bucket.name;
  var key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));

  // Infer the image type.
  var ext = key.split(".").pop();
  if (!ext) {
    console.error('Unable to infer image type for key ' + key);
    return;
  }

  if (VALID_EXT.indexOf(ext.toLowerCase()) < 0) {
    console.log('Skipping non-image ' + key);
    return;
  }

  // Create tasks and run in parellel for all the photo sizes.
  var tasks = [];

  for (var i = 0; i < PHOTO_SIZES.length; i++) {
    tasks.push(createResizeTask(bucket, key, ext, PHOTO_SIZES[i]));
  }

  async.series(tasks, function (err) {
    if (err) context.done(err);
    context.done();
  });
}
