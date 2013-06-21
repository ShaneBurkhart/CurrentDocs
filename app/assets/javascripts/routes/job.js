PlanSource.JobsRoute = Ember.Route.extend({
	model : function(){
		return PlanSource.Job.find();
	}
});