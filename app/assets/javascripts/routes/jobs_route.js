PlanSource.JobsIndexRoute = Ember.Route.extend({
	
	model : function(){
		return PlanSource.Job.find();
	}
	
});
