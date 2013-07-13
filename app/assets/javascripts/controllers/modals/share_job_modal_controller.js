PlanSource.ShareJobController = Ember.ObjectController.extend({

	shareJob : function(){
		var self = this;
		var container = $("#share-email"),
		email = container.val();
		if(!email || email == "" || !email.match(/\A\S+@\S+\.\S+\z/)){
			this.error("Not a valid email.");
			return;
		}
		$.post("/api/shares", {
			"share" : {"job_id" : this.get("model").get("id"), "email" : email}
			},
			function(data){
				if(data.share && data.share.id){
					self.get("shares").pushObject(PlanSource.Share.create(data.share));
					self.get("parent").updateJobs();
					self.info("Succesfully shared with " + data.share.user.email);
				}else{
					if(data.error)
						self.error(data.error);
					else
						self.error("An error occured when sharing with " + email);
				}
			},
			"json"
		);
		container.val("");
	},

	numShares : function(){
		return this.get("shares").length;
	}.property("shares"),

	removeShare : function(share){
		this.get("model").get("shares").removeObject(share);
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.shareJob();
	},

	error : function(error){
		var control = $(".control-group"),
		text = control.find(".help-inline");
		control.addClass("error");
		text.text(error);
	},

	info : function(info){
		var control = $(".control-group"),
		text = control.find(".help-inline");
		control.addClass("info");
		text.text(info);
	}

});