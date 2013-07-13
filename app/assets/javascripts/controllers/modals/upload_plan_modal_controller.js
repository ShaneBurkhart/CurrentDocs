PlanSource.UploadPlanController = Ember.ObjectController.extend({

	uploadPlan : function(){
		var self = this;
		var file = $("#file");
		if(!file.val() || file.val() == "")
			return;
		var parts = file.val().split("\.");
		if(parts[parts.length - 1].toLowerCase() != "pdf")
			return;
		var plan_id = this.get("id");
		$("#plan_id").val(plan_id);
		$("#plan_source_upload_form").upload("/api/upload", function(){
       $(".loading").slideUp(75);
       self.get("parent").updatePlans();
		}, function(p){
      $(".loading").slideDown(75);
      $(".loading-percent").text(Math.floor(p.loaded/p.total*100));
		});
		file.val("");
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addPlan();
	}

});