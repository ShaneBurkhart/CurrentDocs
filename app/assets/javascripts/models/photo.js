PlanSource.Photo = Ember.Object.extend({
});

PlanSource.Photo.reopenClass({
  baseUrl : "/api/photos",

  submitUrl: function () {
    return PlanSource.Photo.url() + "/submit";
  },

  url : function(plan_id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = PlanSource.getProtocol() + host + PlanSource.Photo.baseUrl;
    if(plan_id) return u + "/" + plan_id;
    return u;
  },

  submitPhotos: function (tempPhotos, jobId, callback) {
    // id, date_taken
    var tempPhotos = tempPhotos || [];

    $.ajax({
      url: PlanSource.Photo.submitUrl(),
      type: 'POST',
      data : {
        photos: tempPhotos,
        job_id: jobId,
      },
    }).then(function(data, t, xhr){
      if (!$.isEmptyObject(data)) {
        return callback(true);
      } else {
        return callback(undefined);
      }
    })
  }
});
