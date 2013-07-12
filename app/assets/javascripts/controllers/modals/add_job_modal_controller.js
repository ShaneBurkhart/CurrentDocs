PlanSource.AddJobController = Ember.ObjectController.extend({

	content : {},

	addJob : function(){
		var container = $("#new-job-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var job = PlanSource.Job.create({"name" : name});
		this.get("parent").addJob(job);
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addJob();
	}

});