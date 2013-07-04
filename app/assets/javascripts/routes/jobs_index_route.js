PlanSource.JobsIndexRoute = Ember.Route.extend({

	events : {
		close : function(){
			this.render("nothing", {into : "jobs", outlet : "modal"});
		},

		openAddJobModal : function(){
			this.render("modals/add_job", {into : "jobs", outlet : "modal", controller : "add_job"});
		},

		openDeleteJobModal : function(model){
			this.controllerFor("delete_job").set("model", model);
			this.render("modals/delete_job", {into : "jobs", outlet : "modal", controller : "delete_job"});
		},

		openEditJobModal : function(model){
			this.controllerFor("edit_job").set("model", model);
			this.render("modals/edit_job", {into : "jobs", outlet : "modal", controller : "edit_job"});
		}
	},

	model : function(){
		return PlanSource.Job.find();
	}

});
