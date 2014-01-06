PlanSource.JobRoute = Ember.Route.extend({
  events : {
    close : function(){
      this.render("nothing", {into : "jobs", outlet : "modal"});
    },

    openAddPlanModal : function(){
      this.controllerFor("add_plan").set("model", this.get("controller").get("model"));
      this.controllerFor("add_plan").set("parent", this.controllerFor("plans"));
      this.render("modals/add_plan", {into : "jobs", outlet : "modal", controller : "add_plan"});
    },

    openUploadPlanModal : function(model){
      this.controllerFor("upload_plan").set("model", model);
      this.controllerFor("upload_plan").set("parent", this.controllerFor("plans"));
      this.render("modals/upload_plan", {into : "jobs", outlet : "modal", controller : "upload_plan"});
    },

    openDeletePlanModal : function(model){
      this.controllerFor("delete_plan").set("model", model);
      this.controllerFor("delete_plan").set("parent", this.controllerFor("plans"));
      this.render("modals/delete_plan", {into : "jobs", outlet : "modal", controller : "delete_plan"});
    },

    openEditPlanModal : function(model){
      this.controllerFor("edit_plan").set("model", model);
      this.controllerFor("edit_plan").set("job", this.get("controller").get("model"));
      this.controllerFor("edit_plan").set("parent", this.controllerFor("plans"));
      this.render("modals/edit_plan", {into : "jobs", outlet : "modal", controller : "edit_plan"});
    },

    openPrintSetModal : function(){
      this.controllerFor("print_set").set("model", this.get("controller").get("model"));
      this.controllerFor("print_set").set("parent", this.controllerFor("plans"));
      this.render("modals/print_set", {into : "jobs", outlet : "modal", controller : "print_set"});
    }
  },

  setupController: function(controller, model) {
    controller.set("model", model);
    this.controllerFor('plans').set('content', model.get("plans"));
    this.controllerFor('plans').set('job', model);
  },

  renderTemplate : function(){
    this.render("job.index");
    this.render("plans.index", {
      into : "job.index",
      controller : "plans"
    });
  },

  model : function(param){
    return PlanSource.Job.find(param.job_id);
  }

});
