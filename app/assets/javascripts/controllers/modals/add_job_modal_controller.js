PlanSource.AddJobController = Ember.ObjectController.extend({

	addJob : function(){
		var container = $("#new-job-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var job = PlanSource.Job.createRecord({"name" : name});
		job.save();
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addJob();
	}

});