PlanSource.JobController = Ember.ObjectController.extend({

	delete : function(){
		var job = this.get('model');
	  job.deleteRecord();
	  job.save();
	},

	isMe : function(me){
		return this.get('model').get('user').get('name') == user
	}
	
});