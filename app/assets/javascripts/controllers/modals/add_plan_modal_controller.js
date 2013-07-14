PlanSource.AddPlanController = Ember.ObjectController.extend({

	addPlan : function(){
		var container = $("#new-plan-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var plan = PlanSource.Plan.create({"plan_name" : name, "job" : this.get("model")});
    if(this.get("parent").addPlan(plan))
			this.send("close");
		else
			this.planError("That plan already exists");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addPlan();
	},

	planError : function(error){
		var text = $("#new-plan-name").siblings(".help-inline"),
			cont = text.parent().parent();
		cont.addClass("error");
		text.text(error);
	}

});