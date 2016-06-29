PlanSource.PlanRecord = Ember.Object.extend({

  init : function(){
    this.setProperties(this.getProperties("plan"));
  },

  setProperties : function(hash){
    if(hash.plan){
      var plan = plan
      this.set("plan", plan);
      delete hash.plan
    }
    Ember.setProperties(this, hash);
  }
});

PlanSource.PlanRecord.reopenClass({
  baseUrl : "/api/plans/records",
  planRecords: Em.A(),

  url : function(id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = "http://" + host + PlanSource.PlanRecord.baseUrl;
    if(id) return u + "/" + id;
    return u;
  },

  _getPlanRecordsFromServer: function(id) {
    var that = this;
    Em.Deferred.promise(function(p){
      p.resolve($.get(PlanSource.PlanRecord.url(id)).then(function(data){
        that._clearPlanRecords();
        console.log(data);
        data.plans.forEach(function(planRecord){
          that.planRecords.pushObject(PlanSource.PlanRecord.create(planRecord.plans));
        });
        return that.planRecords;
      }));
    });
  },

  _clearPlanRecords: function() {
    // We have to copy the length attribute so we can loop
    // over everything.
    var l = this.planRecords.length;
    for(var i = 0; i < l; i++) {
      this.planRecords.removeAt(0);
    }
  }

});
