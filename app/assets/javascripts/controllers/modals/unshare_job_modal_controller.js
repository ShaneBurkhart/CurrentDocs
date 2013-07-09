PlanSource.UnshareJobController = Ember.ObjectController.extend({

	unshareJob : function(){
		this.get("model").get("shares").each(function(share){
			if(share.get("user").get("id") == user_id){
				share.deleteRecord();
  			share.save();
			}
		});
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addJob();
	}

});