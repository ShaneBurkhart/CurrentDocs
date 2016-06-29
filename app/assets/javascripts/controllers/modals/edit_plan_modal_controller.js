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
    if( csi != "" && ( !csi.match(/^(0|[1-9]\d*)$/) || csi.length != 6)) {
        this.error("#edit-plan-csi", "Must be six digit number or empty.");
        return;
    }else{
        this.get("model").set("csi", csi);
    }
    if(num && num != "")
    	this.get("model").set("plan_num", num);
		this.get("model").save().then(function(){
			self.get("parent").updatePlans();
		});
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.editPlan();
	}


});