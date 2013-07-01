PlanSource.Modal = Ember.View.extend({
	isShowing : false,

	hide : function(){
		this.set("isShowing", false);
	},

	close : function(){
		this.set("isShowing", false);
	},

	show : function(){
		this.set("isShowing", true);
	}

});

PlanSource.AddJobModal = PlanSource.Modal.extend({

	templateName : "modals/add_job",

	createJob : function(){
		var container = $("#new-job-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var job = PlanSource.Job.createRecord({"name" : name});
		job.save();
		container.val("");
		this.hide();
	}

});

PlanSource.DeleteJobModal = PlanSource.Modal.extend({

	templateName : "modals/delete_job",

	tagName : "li",

	deleteJob : function(){
		var job = this.get('model');
		job.deleteRecord();
	  job.save();
	  this.send("hide");
	}

});

PlanSource.EditJobModal = PlanSource.Modal.extend({

	templateName : "modals/edit_job",

	tagName : "li",

	editJob : function(){
		this.get("model").save();
		this.send("hide");
	}

});