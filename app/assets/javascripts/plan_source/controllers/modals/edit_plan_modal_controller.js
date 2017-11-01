PlanSource.EditPlanController = PlanSource.ModalController.extend({
	job : {},


	initQuill:function(){
		if(this.get('tab') == 'ASI'){
			if($("#edit-plan-description").length > 0){
				editor.setContents(JSON.parse(this.get("model").get("description")));
			}
		}
	},

	closeModal : function(){
		$('#myModal').modal('hide');
		$('body').removeClass('modal-open');
		$('#myModal').on('hidden', function(){
			$(this).data('modal', null);
		});
		this.send('close');
	},

	filenameOrDefault:function(){
		console.log("filename", this.get('filename'));
		if(this.get('filename') == null){
			return "No file attached";
		}
		return this.get('filename');
	}.observes('filename'),

	editPlan : function(){
		var self = this;
		var name = $("#edit-plan-name").val(),
      num = $("#edit-plan-num").val(),
      csi = $("#edit-plan-csi").val(),
      status = $("#edit-select-status").val(),
      code = $("#edit-plan-code").val(),
      tags = $("#edit-plan-tags").val(),
      description = $("#edit-plan-description").val();
    var plan = this.get("model");
    var jobController = this.get("parent");

		this.clearAllErrors();
		this.clearAllInfo();

		if (name != this.get("plan_name") && jobController.planExists(name)) {
			this.error("#edit-plan-name", "That plan name already exists!");
			return;
		} else {
			if (name && name != "") plan.set("plan_name", name);
		}

		if (this.get('tab') == 'Shops') {
			if (csi != "") csi = csi.replace(/ +/g, '');

			// Ensure CSI code is either empty or a six digit number.
			if (csi != "" && (!csi.match(/^(\d*)$/) || csi.length != 6)) {
				this.error("#edit-plan-csi", "Must be six digit number or empty.");
				return;
			} else {
				plan.set("csi", csi);
				plan.set("status", status);
			}
		} else if (this.get('tab') == 'ASI') {
			if(code != "") code = code.replace(/ +/g, '');

			// Ensure ASI code is either empty or a 12 digit number.
			if (code.length > 12) {
				this.error("#edit-plan-code", "Must be 12 characters or less.");
				return;
			} else {
				plan.set("code", code);
				plan.set("description", JSON.stringify(editor.getContents()));
				plan.set("tags", tags);
			}
		} else {
			if (!num.match(/^(0|[1-9]\d*)$/)) {
				this.error("#edit-plan-name", "That is not a valid plan number!");
				return;
			} else {
				if (num && num != ""){
					plan.set("plan_num", num);
				}
			}
		}

		plan.save().then(function(){
			jobController.updatePlans();
		});

		// Save file if file one exists
		var file = $("#file");
		if (file.val() || file.val() != "") {
			this.send('uploadPlan');
		}

		// Save plan history archived states
		self.savePlanRecords();

		this.send('closeModal');
	},

	savePlanRecords:function(){
		var archivedBoxes = $('.archived-box');
		var hash = {};
		archivedBoxes.each(function(index, box){
			hash[$(box).data('id')] = $(box).is(":checked")
		});
		this.get('model').upatePlanRecords(hash);
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
		this.get('model').getPlanRecords();
		file.val("");
		// this.send("close");
	},


	keyPress : function(e){
		// Enter key
		if (e.keyCode == 13)
			this.editPlan();
		// Esc key
		if (e.keyCode == 27)
			this.send('close');
	}
});
