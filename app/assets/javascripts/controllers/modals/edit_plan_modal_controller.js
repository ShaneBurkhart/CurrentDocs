PlanSource.EditPlanController = Ember.ObjectController.extend({

	job : {},

	editPlan : function(){
		var self = this;
		var name = $("#edit-plan-name").val(),
    		num = $("#edit-plan-num").val();
    if(!num.match(/^(0|[1-9]\d*)$/)){
    	this.planError("That is not a valid plan number!");
    	return;
    }
    if(name != this.get("plan_name") && this.get("parent").planExists(name)){
    	this.planError("That plan name already exists!");
    	return;
    }
    if(name && name != "")
    	this.get("model").set("plan_name", name);
    if(num && num != "")
    	this.get("model").set("plan_num", num);
		this.get("model").save().then(function(){
			self.get("parent").updatePlans();
		});
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.editPlan();
	},

	planError : function(error){
		var text = $("#edit-plan-name").siblings(".help-inline"),
			cont = text.parent().parent();
		cont.addClass("error");
		text.text(error);
	}


});