PlanSource.Plan = Ember.Object.extend({

	didUpdate : function(){
		PlanSource.Job.find();
	}
});