PlanSource.PlansController = Ember.ArrayController.extend({
	sortProperties: ['plan_num'],
  sortAscending: true,

  addPlan : function(plan){
  	var self = this;
		this.get("content").pushObject(plan);
		plan.save().then(function(data){
      if(data == false)
        self.get("content").removeObject(plan);
    });
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
	}

});