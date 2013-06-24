PlanSource.JobController = Ember.ObjectController.extend({

	delete : function(){
		var job = this.get('model');
	  job.deleteRecord();
	  job.save();
	}
	
});