PlanSource.Share = Ember.Object.extend({

	didDelete : function(){
		PlanSource.Job.find();
	}
});