PlanSource.PlansController = Ember.ArrayController.extend({
	sortProperties: ['plan_num'],
  sortAscending: true,

  addPlan : function(plan){
  	if(this.planExists(plan)) return false;
  	var self = this;
		this.get("content").pushObject(plan);
		plan.save().then(function(data){
      if(data == false)
        self.get("content").removeObject(plan);
    });
    return true;
	},

	removePlan : function(plan){
		var self = this;
		this.get("content").removeObject(plan);
		plan.deleteRecord();
		plan.save().then(function(){
			self.updatePlans();
		});
	},

	updatePlans : function(){
		var self = this;
		PlanSource.Job.find(this.get("job").get("id")).then(function(job){
			self.set("content", job.get("plans"))
		});
	},

	planExists : function(new_plan){
    for(var i = 0 ; i < this.get("content").length ; i++){
      var plan = this.get("content")[i];
      if(plan.get("plan_name") == new_plan.get("plan_name"))
        return true;
    }
    return false;
  }

});