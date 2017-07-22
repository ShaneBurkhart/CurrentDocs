PlanSource.Submittal = Ember.Object.extend({
  setProperties: function (hash) {
    if (hash.data) {
      this.set("rawData", hash.data);
      this.set("data", JSON.parse(hash.data))
      // Don't want to set data after we manually did it.
      delete hash.data
    }

    Ember.setProperties(this, hash);
  }
});

PlanSource.Submittal.reopenClass({
  baseUrl : "/api/submittals",

  url : function(plan_id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = PlanSource.getProtocol() + host + PlanSource.Submittal.baseUrl;
    if(plan_id) return u + "/" + plan_id;
    return u;
  }

});
