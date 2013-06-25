PlanSource.PlanController = Ember.ObjectController.extend({

	delete : function(){
		var plan = this.get('model');
	  plan.deleteRecord();
	  plan.save();
	},

	upload : function(event){
		var id = this.get("model").get("id");
		$("#plan_id").val(id);
		$("#file").trigger("click");
	},

	isEditing : false,

	edit : function(){
		this.set("isEditing", true);
	}, 

	doneEditing : function(){
		this.set("isEditing", false);
		this.commit();
	}

});