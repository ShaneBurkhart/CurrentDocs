PlanSource.PlansController = Ember.ArrayController.extend({
  needs: ['job'],
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
			self.set("content", job.getPlansByTab(self.get('controllers.job.tab')))
		});
	},

	planExists : function(new_plan){
		var name;
		if (typeof new_plan == 'string' || new_plan instanceof String)
			name = new_plan;
		else
			name = new_plan.get("plan_name");
    for(var i = 0 ; i < this.get("content").length ; i++){
      var plan = this.get("content")[i];
      if(plan.get("plan_name") == name)
        return true;
    }
    return false;
  },

  updateTab: function() {
    var jobController = this.get('controllers.job');
    this.set('content', jobController.get('model').getPlansByTab(jobController.get('tab')));
  }.observes('controllers.job.tab')
});
