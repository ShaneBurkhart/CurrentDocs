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
    }
  },

  setupController: function(controller, model) {
    var plansController = this.controllerFor('plans');
    var tab = plansController.get('tab') || 'Plans';
    switch(true) {
      case model.get('canViewPlansTab'):
        tab = 'Plans';
        break;
      case model.get('canViewShopsTab'):
        tab = 'Shops';
        break;
      case model.get('canViewConsultantsTab'):
        tab = 'Consultants';
        break;
    }

    controller.set("model", model);
    controller.set('tab', tab);

    plansController.set('tab', tab);
    plansController.set('content', model.getPlansByTab(tab));
    plansController.set('job', model);
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
