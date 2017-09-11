var async = require('async');
var path = require('path');
var AWS = require('aws-sdk');
var gm = require('gm').subClass({
    imageMagick: true
});
var util = require('util');
var s3 = new AWS.S3();

var VALID_EXT = ['png', 'jpg', 'jpeg', 'tiff', 'gif'];
var MAX_WIDTH = 100;
var MAX_HEIGHT = 100;

exports.handler = function (event, context, callback) {
  var bucket = event.Records[0].s3.bucket.name;
  var key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
  var keyParts = key.split("/");
  keyParts.splice(0, 1, "thumbnails");
  var destKey = keyParts.join("/")


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

  async.waterfall([
    function download(next) {
      // Download the image from S3 into a buffer.
      s3.getObject({
        Bucket: bucket,
        Key: key,
      }, next);
    },
    function tranform(response, next) {
      gm(response.Body).size(function(err, size) {
        // Infer the scaling factor to avoid stretching the image unnaturally.
        var scalingFactor = Math.min(
          MAX_WIDTH / size.width,
          MAX_HEIGHT / size.height
        );
        var width  = scalingFactor * size.width;
        var height = scalingFactor * size.height;

        // Transform the image buffer in memory.
        this.resize(width, height)
          .toBuffer(ext, function(err, buffer) {
            if (err) return next(err);

            next(null, response.ContentType, buffer);
          });
      });
    },
    function upload(contentType, data, next) {
      // Stream the transformed image to a different S3 bucket.
      s3.putObject({
        Bucket: bucket,
        Key: destKey,
        Body: data,
        ContentType: contentType
      }, next);
    }],
    function (err) {
      if (err) {
        console.error(
          'Unable to resize ' + bucket + '/' + key +
          ' and upload to ' + bucket + '/' + destKey +
          ' due to an error: ' + err
        );
        return context.done();
      }

      console.log(
        'Successfully resized ' + bucket + '/' + key +
        ' and uploaded to ' + bucket + '/' + destKey
      );

      context.done();
    }
  );
}
