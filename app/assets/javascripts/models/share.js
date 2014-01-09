PlanSource.Share = Ember.Object.extend({

  init : function(){
    this.setProperties(this.getProperties("user", "sharer"));
  },

  setProperties : function(hash){
    if(hash.user){
      this.set("user", PlanSource.User.create(hash.user));
      delete hash.user
    }
    if(hash.sharer){
      this.set("sharer", PlanSource.User.create(hash.sharer));
      delete hash.sharer
    }
    Ember.setProperties(this, hash);
  },

  deleteRecord : function(){
    this.destroy();
  },

  isSharer : function(){
    if(this.get("sharer"))
      return this.get("sharer").get("id") == user_id;
    else
      return false;
  }.property("sharer"),

  save : function(){
    if(this.get("isDestroyed") || this.get("isDestroying")){
      return this._deleteRequest();
    }else{
      if(this.get("id")) ///Not news
        return this._updateRequest();
      else
        return this._createRequest();
    }
  },

  _deleteRequest : function(){
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
            url: PlanSource.Share.url(self.get("id")),
            type: 'DELETE'
        }).then(function(data){

        })
      );
    });
  }

});

PlanSource.Share.reopenClass({
  baseUrl : "/api/shares",

  url : function(id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = "http://" + host + PlanSource.Share.baseUrl;
    if(id) return u + "/" + id;
    return u;
  }

});
