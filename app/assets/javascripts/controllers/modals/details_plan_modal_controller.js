PlanSource.DetailsPlanController = PlanSource.ModalController.extend({
	job : {},

	init:function(){
		this._super();
		Ember.run.schedule("afterRender", this, function(){
			this.send("initQuill");
		});
	},

	initQuill:function(){
		if(this.get('tab') == 'ASI'){
			editor.setContents(JSON.parse(this.get("model").get("description")));
		}
	},

	closeModal : function(){
		jQuery('#myModal').modal('hide');
		$('body').removeClass('modal-open');
		this.send('close');
	},

	editPlan : function(){
		var self = this;
		var name = $("#edit-plan-name").val(),
		num = $("#edit-plan-num").val(),
		csi = $("#edit-plan-csi").val(),
		status = $("#edit-select-status").val(),
		code = $("#edit-plan-code").val(),
		affects = $("#edit-plan-links").val(),
		description = $("#edit-plan-description").val();

		this.clearAllErrors();
		this.clearAllInfo();

		if(name != this.get("plan_name") && this.get("parent").planExists(name)){
			this.error("#edit-plan-name", "That plan name already exists!");
			return;
		}else{
			if(name && name != "")
			this.get("model").set("plan_name", name);
		}

		if(this.get('tab') == 'Shops'){
			if(csi != ""){
				csi = csi.replace(/ +/g, '');
			}
			// Ensure CSI code is either empty or a six digit number.
			if( csi != "" && ( !csi.match(/^(\d*)$/) || csi.length != 6)) {
				this.error("#edit-plan-csi", "Must be six digit number or empty.");
				return;
			}else{
				this.get("model").set("csi", csi);
				this.get("model").set("status", status);
			}
		}else if(this.get('tab') == 'ASI'){
			console.log(editor.getContents());
			if(code != ""){
				code = code.replace(/ +/g, '');
			}
			// Ensure CSI code is either empty or a six digit number.
			if( code != "" && ( !code.match(/^(\d*)$/) || code.length != 12)) {
				this.error("#edit-plan-code", "Must be 12 digit number or empty.");
				return;
			}else{
				this.get("model").set("code", code);
				this.get("model").set("description", JSON.stringify(editor.getContents()));
			}
		}else{
			console.log(this);
			if(!num.match(/^(0|[1-9]\d*)$/)){
				this.error("#edit-plan-name", "That is not a valid plan number!");
				return;
			}else{
				if(num && num != ""){
					this.get("model").set("plan_num", num);
				}
			}
		}

		this.get("model").save().then(function(){
			self.get("parent").updatePlans();
		});
		var file = $("#file");
		if(file.val() || file.val() != ""){
			this.send('uploadPlan');
		}

		this.send("closeModal");
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
		PlanSource.PlanRecord._getPlanRecordsFromServer(this.get('id'));
		file.val("");
		// this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
		this.editPlan();

	}


});
