PlanSource.AddPlanView = Ember.View.extend({

	templateName : "add_plan_view",

	isAdding : false,

	add : function(){
		this.set("isAdding", true);
	},

  addPlan: function(evt) {
    var container = $("#new-plan-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    job = this.get("controller").get("model");
    var plan = PlanSource.Plan.createRecord({"pageName" : name});
		job.get("plans").pushObject(plan);
		plan.save();
		container.val("");
		this.set("isAdding", false);
  },

	keyPress: function(e){
		var code = (e.keyCode ? e.keyCode : e.which);
	  if (code == 13)
			this.addPlan(e);
	}

});