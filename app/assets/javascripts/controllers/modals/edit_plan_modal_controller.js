PlanSource.EditPlanController = Ember.ObjectController.extend({

	job : {},

	editPlan : function(){
		var self = this;
		var name = $("#edit-plan-name").val(),
    		num = $("#edit-plan-num").val();
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
	}

});