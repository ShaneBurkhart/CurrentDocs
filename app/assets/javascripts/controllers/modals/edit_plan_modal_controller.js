PlanSource.EditPlanController = PlanSource.ModalController.extend({

	job : {},

	editPlan : function(){
		var self = this;
		var name = $("#edit-plan-name").val(),
    		num = $("#edit-plan-num").val(),
            csi = $("#edit-plan-csi").val();

        this.clearAllErrors();
        this.clearAllInfo();
        if(!num.match(/^(0|[1-9]\d*)$/)){
        	this.error("#edit-plan-name", "That is not a valid plan number!");
        	return;
        }
        if(name != this.get("plan_name") && this.get("parent").planExists(name)){
        	this.error("#edit-plan-name", "That plan name already exists!");
        	return;
        }
        if(name && name != "")
        	this.get("model").set("plan_name", name);

        // Ensure CSI code is either empty or a six digit number.
        if(this.get('tab') == 'Shops'){
            if( csi != "" && ( !csi.match(/^(0|[1-9]\d*)$/) || csi.length != 6)) {
                this.error("#edit-plan-csi", "Must be six digit number or empty.");
                return;
            }else{
                this.get("model").set("csi", csi);
            }
        }
        if(num && num != ""){
        	this.get("model").set("plan_num", num);
        }
		this.get("model").save().then(function(){
			self.get("parent").updatePlans();
		});
		this.send("close");
	},

    uploadPlan : function(){
        if(PlanSource.isUploading)
            this.error("#file", "A file is already uploading.");
        var self = this;
        var file = $("#file");
        this.clearAllErrors();
        this.clearAllInfo();
        if(!file.val() || file.val() == ""){
            this.error("#file", "You must select a file!")
            return;
        }
        // var parts = file.val().split("\.");
        // if(parts[parts.length - 1].toLowerCase() != "pdf"){
        //  this.error("#file", "The file must be a PDF!");
        //  return;
        // }
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
			this.editPlan();
            this.uploadPlan();
	}


});