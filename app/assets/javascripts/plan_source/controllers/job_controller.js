PlanSource.JobController = Ember.ObjectController.extend({
  addPlan : function(plan){
  	if(this.planExists(plan)) return false;

  	var self = this;
    this.get("model.plans").pushObject(plan);

		plan.save().then(function(data){
      if (data == false) {
        self.get("model.plans").removeObject(plan);
      }
    });

    return true;
	},

	removePlan : function(plan){
		var self = this;
		this.get("model.plans").removeObject(plan);

		plan.deleteRecord();
		plan.save().then(function(){
			self.updatePlans();
		});
	},

	updatePlans : function(){
		var self = this;
    var jobId = this.get("model.id");

		PlanSource.Job.find(jobId).then(function(job){
			self.set("model", job);
		});
	},

	planExists : function(new_plan){
		var name;
		if (typeof new_plan == 'string' || new_plan instanceof String) {
			name = new_plan;
    } else {
			name = new_plan.get("plan_name");
    }

    for(var i = 0 ; i < this.get("content").length ; i++){
      var plan = this.get("content")[i];
      if(plan.get("plan_name") == name)
        return true;
    }

    return false;
  }
});
