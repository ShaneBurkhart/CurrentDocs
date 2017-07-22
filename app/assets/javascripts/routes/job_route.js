PlanSource.JobRoute = Ember.Route.extend({
  // Modal stack so we can open modals while in modals and come back.
  _modalStack: [],

  events : {
    close : function(){
      this.closeModal();
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
      var self = this;
      model.getPlanRecordsSync(function(){
        self.controllerFor("edit_plan").set("model", model);
        self.controllerFor("edit_plan").set("job", self.get("controller").get("model"));
        self.controllerFor("edit_plan").set("parent", self.controllerFor("plans"));
        self.render("modals/edit_plan", {into : "jobs", outlet : "modal", controller : "edit_plan"});
      });
    },
    openDetailsPlanModal : function(plan){
      var self = this;
      plan.getPlanRecordsSync(function(){
        plan.getSubmittalsSync(function(){
          self.renderModal("details_plan", {
            model: plan,
            job: self.get("controller").get("model"),
            parent: self.controllerFor("plans"),
          });
        });
      });
    },

    openSubShareLinkModal: function(){
      this.controllerFor("sub_share_link").set("model", this.get("controller").get("model"));
      this.controllerFor("sub_share_link").set("parent", this.controllerFor("plans"));
      this.render("modals/sub_share_link", {into : "jobs", outlet : "modal", controller : "sub_share_link"});
    },

    openSubmittalModal: function(submittal) {
      var job = this.get("controller").get("model");

      this.renderModal("submittal", {
        model: submittal,
        job: job,
      });
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

  renderModal: function (modal, attrs) {
    // Make sure outlet is clear before rendering. Previous modal is saved to stack.
    this.clearOutlet("jobs", "modal");

    this.controllerFor(modal).setProperties(attrs);
    this.render("modals/" + modal, {into : "jobs", outlet : "modal", controller : modal});
    this._modalStack.push(modal);
  },

  closeModal: function () {
    this.clearOutlet('jobs', 'modal');
    this._modalStack.pop();

    var modalsRemaining = this._modalStack.length;
    if (modalsRemaining) {
      var nextModal = this._modalStack[modalsRemaining - 1];
      this.render("modals/" + nextModal, {into : "jobs", outlet : "modal", controller : nextModal});
    }
  },

  model : function(param){
    return PlanSource.Job.find(param.job_id);
  },

  clearOutlet: function(container, outlet) {
    parentView = this.router._lookupActiveView(container);
    parentView.disconnectOutlet(outlet);
  }
});
