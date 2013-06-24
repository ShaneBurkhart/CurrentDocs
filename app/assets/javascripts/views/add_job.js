PlanSource.AddJobView = Ember.View.extend({

	templateName : "add_job_view",

	isAdding : false,

	add : function(){
		this.set("isAdding", true);
	},

  addJob: function(evt) {
    var container = $("#new-job-name"),
    		name = container.val();
    if(!name || name == "")
    	return;
    var job = PlanSource.Job.createRecord({"name" : name});
		job.save();
		container.val("");
		this.set("isAdding", false);
  },

	keyPress: function(e){
		console.log("Adding");
		var code = (e.keyCode ? e.keyCode : e.which);
	  if (code == 13)
			this.addJob(e);
	}

});