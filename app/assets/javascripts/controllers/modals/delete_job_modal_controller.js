PlanSource.DeleteJobController = Ember.ObjectController.extend({

	deleteJob : function(){
		this.get("model").deleteRecord();
		this.get("model").save();
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.deleteJob();
	}

});