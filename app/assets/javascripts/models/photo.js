PlanSource.Photo = Ember.Object.extend({
  current_user_is_owner: function () {
		return this.get("upload_user_id") === window.user_id;
  }.property("upload_user_id"),

  save: function (callback) {
    var self = this;
    var photoJSON = this.getProperties(["description"]);

    $.ajax({
        url: PlanSource.Photo.saveUrl(this.get("id")),
        type: 'POST',
        data : { photo: photoJSON },
    }).then(function(data, t, xhr){
      if (!$.isEmptyObject(data)) {
        self.setProperties(data.photo);
        return callback(self);
      } else {
        return callback(undefined);
      }
    })
  },

  deletePhoto: function (callback) {
    $.ajax({
        url: PlanSource.Photo.deleteUrl(this.get("id")),
        type: 'POST',
    }).then(function(data, t, xhr){
      return callback();
    })
  }
});

PlanSource.Photo.reopenClass({
  baseUrl : "/api/photos",

  deleteUrl: function (id) {
    return PlanSource.Photo.url() + "/" + id + "/destroy";
  },

  saveUrl: function (id) {
    return PlanSource.Photo.url() + "/" + id;
  },

  url : function(photo_id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = PlanSource.getProtocol() + host + PlanSource.Photo.baseUrl;
    if(photo_id) return u + "/" + photo_id;
    return u;
  }

});
