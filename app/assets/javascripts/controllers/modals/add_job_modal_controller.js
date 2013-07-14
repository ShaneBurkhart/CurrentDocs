PlanSource.AddJobController = Ember.ObjectController.extend({

	content : {},

	addJob : function(){
		var container = $("#new-job-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var job = PlanSource.Job.create({"name" : name});
		if(this.get("parent").addJob(job))
			this.send("close");
		else
			this.jobError("The job already exists!");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addJob();
	},

	jobError : function(error){
		var text = $("#new-job-name").siblings(".help-inline"),
			cont = text.parent().parent();
		cont.addClass("error");
		text.text(error);
	}

});