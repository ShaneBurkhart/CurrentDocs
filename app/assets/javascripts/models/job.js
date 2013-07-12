PlanSource.Job = Ember.Object.extend({

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
  }.property("isShared")

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
  }

});