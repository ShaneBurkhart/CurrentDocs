PlanSource.Job = Ember.Object.extend({

  init : function(){
    this.setProperties(this.getProperties("user", "plans", "shares"));
  },

  setProperties : function(hash){
    if(hash.user){
      this.set("user", PlanSource.User.create(hash.user));
      delete hash.user
    }
    if(hash.plans){
      var plans = Em.A();
      hash.plans.forEach(function(plan){
        plans.pushObject(PlanSource.Plan.create(plan));
      });
      this.set("plans", plans);
      delete hash.plans
    }
    if(hash.shares){
      var shares = Em.A();
      hash.shares.forEach(function(share){
        shares.pushObject(PlanSource.Share.create(share));
      });
      this.set("shares", shares);
      delete hash.shares
    }
    Ember.setProperties(this, hash);
  },

  getPlansByTab: function(tab) {
    var plansForTab = Em.A();
    var plans = this.get('plans');
    for(var i = 0; i < plans.length; i++) {
      if(plans[i].get('tab') === tab) {
        plansForTab.pushObject(plans[i]);
      }
    }
    return plansForTab;
  },

	username : function(){
		if(this.get("user"))
    	return this.get('user').get('id') == user_id ? "Me" : this.get("user").get("fullName");
    else
    	return "";
	}.property('user'),

	isShared : function(){
  	if(this.get("user")) {
  	  return !this.get("isMyJob");
        } else
  	  return false;
  }.property("user"),

  isMyJob : function(){
    if(!this.get("user")) {
      return false;
    }
    return this.get("user").get("id") == user_id;
  }.property("user"),

  sorter : function(){ //either a 1 or 0 depending on isShared. Its for order
    var s = this.get("isShared") == false ? '0' : '1';
    return s + this.get("name").toLowerCase();
  }.property("isShared"),

  deleteRecord : function(){
    this.destroy();
  },

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

  _createRequest : function(){
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
            url: PlanSource.Job.url(),
            type: 'POST',
            data : { job : self.getProperties("name")}
        }).then(function(data, t, xhr){
          if(!$.isEmptyObject(data)){
            self.setProperties(data.job);
            return true;
          }else
            return false;
        })
      );
    });
  },

  _updateRequest : function(){
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
            url: PlanSource.Job.url(self.get("id")),
            type: 'PUT',
            data : { job : self.getProperties("name", "archived")}
        }).then(function(data){
          self.setProperties(data.job);
        })
      );
    });
  },

  _deleteRequest : function(){
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
            url: PlanSource.Job.url(self.get("id")),
            type: 'DELETE'
        }).then(function(data){

        })
      );
    });
  }

});

PlanSource.Job.reopenClass({
  baseUrl : "/api/jobs",

  jobs: Em.A(),
  nonArchivedJobs: Em.A(),
  archivedJobs: Em.A(),

  url : function(id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = "http://" + host + PlanSource.Job.baseUrl;
    if(id) return u + "/" + id;
    return u;
  },

  findNonArchivedJobs: function() {
    this._getJobsFromServer();
    return this.nonArchivedJobs;
  },

  findArchivedJobs: function() {
    this._getJobsFromServer();
    return this.archivedJobs;
  },

  findAll : function(){
    this._getJobsFromServer();
    return this.jobs;
  },

  _getJobsFromServer: function() {
    var that = this;
    Em.Deferred.promise(function(p){
      p.resolve($.get(PlanSource.Job.url()).then(function(data){
        that._clearJobs();
        data.jobs.forEach(function(job){
          that.jobs.pushObject(PlanSource.Job.create(job));
        });
        that.sortJobsByArchived(that.jobs);
        return that.jobs;
      }));
    });
  },

  sortJobsByArchived : function(jobs) {
    var l = jobs.length;
    for(var i = 0; i < l; i++) {
      var job = jobs[i];
      if(job.archived) {
        this.archivedJobs.pushObject(job)
      } else {
        this.nonArchivedJobs.pushObject(job)
      }
    }
  },

  _clearJobs: function() {
    // We have to copy the length attribute so we can loop
    // over everything.
    var l = this.jobs.length;
    for(var i = 0; i < l; i++) {
      this.jobs.removeAt(0);
    }
    var l = this.nonArchivedJobs.length;
    for(var i = 0; i < l; i++) {
      this.nonArchivedJobs.removeAt(0);
    }
    var l = this.archivedJobs.length;
    for(var i = 0; i < l; i++) {
      this.archivedJobs.removeAt(0);
    }
  },

  find : function(id){
    if(!id) return PlanSource.Job.findAll();
    return Em.Deferred.promise(function(p){
      p.resolve($.get(PlanSource.Job.url(id)).then(function(data){
        return PlanSource.Job.create(data.job);
      }));
    });
  }
});
