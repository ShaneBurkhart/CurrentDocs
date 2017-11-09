PlanSource.JobIndexRoute = Ember.Route.extend({
	redirect : function(){
		this.transitionTo("job.plans");
	}
});
