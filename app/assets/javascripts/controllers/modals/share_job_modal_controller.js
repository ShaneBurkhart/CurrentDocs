PlanSource.ShareJobController = Ember.ObjectController.extend({

	shareJob : function(){
        var self = this;
		var container = $("#share-email"),
    		email = container.val();
    if(!email || email == "" || !email.match(/\S+@\S+\.\S+/))
    	return;
    $.post("/api/shares",
    	{"share" : {"job_id" : this.get("model").get("id"), "email" : email}},
    	function(data){
    		self.get("parent").updateJobs();
    	},
    	"json");
		this.send("close");
	},

    removeShare : function(share){
        this.get("model").get("shares").removeObject(share);
    },

	keyPress : function(e){
		if (e.keyCode == 13)
			this.shareJob();
	}

});