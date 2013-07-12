PlanSource.Job = Ember.Object.extend({

  init : function(){
    this.set("user", PlanSource.User.create(this.get("user")));
    var plans = Em.A();
    this.get("plans").forEach(function(plan){
      plans.pushObject(PlanSource.Plan.create(plan));
    });
    this.set("plans", plans);
    var shares = Em.A();
    this.get("shares").forEach(function(share){
      shares.pushObject(PlanSource.Share.create(share));
    });
    this.set("shares", shares);
  },

	username : function(){
		if(this.get("user"))
    	return this.get('user').get('id') == user_id ? "Me" : this.get("user").get("fullName");
    else
    	return "";
	}.property('user'),

	isShared : function(){
  	if(this.get("user"))
  		return this.get("user").get("id") != user_id;
  	else
  		return false;
  }.property("user"),

  sorter : function(){ //either a 1 or 0 depending on isShared. Its for order
  	return this.get("isShared") == false ? 0 : 1;
  }.property("isShared"),

  deleteRecord : function(){
    this.destroy();
    console.log("Destroyed Job");
  },

  save : function(){
    if(this.get("isDestroyed") || this.get("isDestroying")){
      console.log("Save: Destroying");
      return this._deleteRequest();
    }else{
      console.log("Save: Updating");
    }
  },

  _deleteRequest : function(){
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
            url: PlanSource.Job.url(self.get("id")),
            type: 'DELETE'
        }).then(function(data){
          console.log(data);
        })
      );
    });
  }

});

PlanSource.Job.reopenClass({
  baseUrl : "/api/jobs",

  url : function(id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = "http://" + host + PlanSource.Job.baseUrl;
    if(id) return u + "/" + id;
    return u;
  },

  findAll : function(){
    return Em.Deferred.promise(function(p){
      p.resolve($.get(PlanSource.Job.url()).then(function(data){
        var jobs = Em.A();
        data.jobs.forEach(function(job){
          jobs.pushObject(PlanSource.Job.create(job));
        });
        return jobs;
      }));
    });
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