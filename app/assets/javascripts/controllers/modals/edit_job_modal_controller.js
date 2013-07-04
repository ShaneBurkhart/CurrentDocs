PlanSource.EditJobController = Ember.ObjectController.extend({

	editJob : function(){
		var container = $("#edit-job-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    this.get("model").set("name", name);
		this.get("model").save();
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.editJob();
	}

});