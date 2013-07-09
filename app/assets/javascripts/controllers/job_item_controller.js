PlanSource.JobItemController = Ember.ObjectController.extend({

  isShared : function(){
  	if(this.get("model").get("user"))
  		return this.get("model").get("user").get("id") == user_id;
  	else
  		return false;
  }.property("isValid")

});