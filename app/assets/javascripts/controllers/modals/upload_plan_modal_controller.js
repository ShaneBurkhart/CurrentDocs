PlanSource.UploadPlanController = PlanSource.ModalController.extend({

	uploadPlan : function(){
		var self = this;
		var file = $("#file");
		var page_size = $("#page_size");
		this.clearAllErrors();
		this.clearAllInfo();
		if(!page_size.val() || page_size.val() == "" || page_size.val() == "Select Size"){
			this.error("#page_size", "You must select a page size!")
			return;
		}
		if(!file.val() || file.val() == ""){
			this.error("#file", "You must select a file!")
			return;
		}
		var parts = file.val().split("\.");
		if(parts[parts.length - 1].toLowerCase() != "pdf"){
			this.error("#file", "The file must be a PDF!");
			return;
		}
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

	pageSizes : function(){
		return PlanSource.page_sizes;
	}.property(),

	keyPress : function(e){
		if (e.keyCode == 13)
			this.addPlan();
	}

});