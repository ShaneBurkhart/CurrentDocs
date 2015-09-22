PlanSource.PlansController = Ember.ArrayController.extend({
  needs: ['job'],
	sortProperties: ['plan_num'],
  sortAscending: true,

  addPlan : function(plan){
  	if(this.planExists(plan)) return false;
  	var self = this;
		this.get("controllers.job.model.plans").pushObject(plan);
    this.updateTab();
		plan.save().then(function(data){
      if(data == false) {
        self.get("controller.job.model.plans").removeObject(plan);
        this.updateTab();
      }
    });
    return true;
	},

	removePlan : function(plan){
		var self = this;
		this.get("controllers.job.model.plans").removeObject(plan);
    this.updateTab();
		plan.deleteRecord();
		plan.save().then(function(){
			self.updateTab();
		});
	},

	updatePlans : function(){
		var self = this;
		PlanSource.Job.find(this.get("job").get("id")).then(function(job){
			self.set("controllers.job.model", job);
      self.updateTab();
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
