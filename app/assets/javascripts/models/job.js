PlanSource.Job = Ember.Object.extend({

  init : function(){
    this.setProperties(this.getProperties("print_set", "user", "plans", "shares"));
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
    if(hash.print_set){
      var print_set_plans = Em.A();
      hash.print_set.plan_ids.forEach(function(plan_id){
        this.get("plans").forEach(function(plan){
          if(plan.get("id") == 10)
            print_set_plans.pushObject(plan);
        });
      });
      print_set = PlanSource.PrintSet.create(hash.print_set);
      print_set.set("plans", print_set_plans);
      this.set("print_set", print_set);
      delete hash.print_set
    }
    Ember.setProperties(this, hash);
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

  canReshare : function(){
    var bool = false;
    this.get("shares").forEach(function(share){
      if(share.get("user").get("id") == user_id){
        bool = share.get("can_reshare");
        return;
      }
    });
    return bool;
  }.property("shares.@each"),

  sorter : function(){ //either a 1 or 0 depending on isShared. Its for order
  	return this.get("isShared") == false ? 0 : 1;
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
            data : { job : self.getProperties("name")}
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

  url : function(id){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = "http://" + host + PlanSource.Job.baseUrl;
    if(id) return u + "/" + id;
    return u;
  },

  findAll : function(){
    var jobs = Em.A();
    Em.Deferred.promise(function(p){
      p.resolve($.get(PlanSource.Job.url()).then(function(data){
        data.jobs.forEach(function(job){
          jobs.pushObject(PlanSource.Job.create(job));
        });
        return jobs;
      }));
    });
    return jobs;
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