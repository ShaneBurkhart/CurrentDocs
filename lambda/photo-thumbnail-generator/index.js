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

  async.waterfall([
    function download(next) {
      // Download the image from S3 into a buffer.
      s3.getObject({
        Bucket: bucket,
        Key: key,
      }, next);
    },
    function tranform(response, next) {
      var keyParts = key.split("/");

      gm(response.Body).size(function(err, size) {
        var self = this;

        var createResizeTask = function (photoSize) {
          // Change "directory" from photos/ to photos-<name>/
          keyParts.splice(0, 1, "photos-" + photoSize.name);
          var destKey = keyParts.join("/");
          var scalingFactor = Math.min(
            photoSize.max_width / size.width,
            photoSize.max_height / size.height
          );

          var width = scalingFactor * size.width;
          var height = scalingFactor * size.height;

          return function (doneScaling) {
            // Infer the scaling factor to avoid stretching the image unnaturally.
            // Transform the image buffer in memory.
            self.resize(width, height)
              .toBuffer(ext, function(err, buffer) {
                if (err) return doneScaling(err);

                // Stream the transformed image to a different S3 bucket.
                s3.putObject({
                  Bucket: bucket,
                  Key: destKey,
                  Body: buffer,
                  ContentType: response.ContentType,
                  ACL: 'public-read',
                }, doneScaling);
              });
          };
        };

        // Create tasks and run in parellel for all the photo sizes.
        var tasks = [];
        for (var i = 0; i < PHOTO_SIZES.length; i++) { tasks.push(createResizeTask(PHOTO_SIZES[i])); }
        async.series(tasks, next);
      });
    }],
    function (err) {
      if (err) {
        console.error(
          'Unable to resize ' + bucket + '/' + key +
          ' due to an error: ' + err
        );
        return context.done();
      }

      console.log('Successfully resized ' + bucket + '/' + key);

      context.done();
    }
  );
}
