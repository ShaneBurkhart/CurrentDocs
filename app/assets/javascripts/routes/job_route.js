PlanSource.JobRoute = Ember.Route.extend({
	events : {
		close : function(){
			this.render("nothing", {into : "jobs", outlet : "modal"});
		},

		openAddPlanModal : function(){
			this.controllerFor("add_plan").set("model", this.get("controller").get("model"));
			this.render("modals/add_plan", {into : "jobs", outlet : "modal", controller : "add_plan"});
		},

		openDeletePlanModal : function(model){
			console.log(model);
			this.controllerFor("delete_plan").set("model", model);
			this.render("modals/delete_plan", {into : "jobs", outlet : "modal", controller : "delete_plan"});
		},

		openEditPlanModal : function(model){
			this.controllerFor("edit_plan").set("model", model);
			this.controllerFor("edit_plan").set("job", this.get("controller").get("model"));
			this.render("modals/edit_plan", {into : "jobs", outlet : "modal", controller : "edit_plan"});
		}
	},

	setupController: function(controller, model) {
		controller.set("model", model);
    this.controllerFor('plans').set('content', model.get("plans"));
  },

	renderTemplate : function(){
		this.render("job.index");
		this.render("plans.index", {
			into : "job.index",
			controller : "plans"
		});
	}

});