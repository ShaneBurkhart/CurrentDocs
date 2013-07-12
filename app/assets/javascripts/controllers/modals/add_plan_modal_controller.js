PlanSource.AddPlanController = Ember.ObjectController.extend({

	addPlan : function(){
		var container = $("#new-plan-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var plan = PlanSource.Plan.create({"plan_name" : name, "job" : this.get("model")});
    this.get("parent").addPlan(plan);
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addPlan();
	}

});