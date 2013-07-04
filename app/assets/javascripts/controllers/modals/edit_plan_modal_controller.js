PlanSource.EditPlanController = Ember.ObjectController.extend({

	job : {},

	editPlan : function(){
		var name = $("#edit-plan-name").val(),
    		num = $("#edit-plan-num").val();
    if(name && name != "")
    	this.get("model").set("planName", name);
    if(num && num != "")
    	this.get("model").set("planNum", num);
		this.get("model").save();
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.editPlan();
	}

});