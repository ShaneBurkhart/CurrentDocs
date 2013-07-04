PlanSource.AddPlanController = Ember.ObjectController.extend({

	addPlan : function(){
		var container = $("#new-plan-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var plan = PlanSource.Plan.createRecord({"planName" : name, "job" : this.get("model")});
		plan.save();
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addPlan();
	}

});