PlanSource.UnshareJobController = Ember.ObjectController.extend({

	unshareJob : function(){
		var self = this;
		this.get("model").get("shares").forEach(function(share){
			if(share.get("user").get("id") == user_id){
				share.deleteRecord();
				share.save();
				self.get("model").deleteRecord();
			}
		});
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.unshareJob();
	}

});