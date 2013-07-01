PlanSource.JobRoute = Ember.Route.extend({
	setupController: function(controller, model) {
		console.log(model.get("plans"));
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