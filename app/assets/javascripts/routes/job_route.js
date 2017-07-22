PlanSource.JobRoute = Ember.Route.extend({
  // Modal stack so we can open modals while in modals and come back.
  _modalStack: [],

  events : {
    close : function(){
      this.closeModal();
    },

    openAddPlanModal : function(){
      self.renderModal("add_plan", {
        model: self.get("controller").get("model"),
        parent: this.controllerFor("plans"),
      });
    },

    openUploadPlanModal : function(model){
      self.renderModal("upload_plan", {
        model: model,
        parent: this.controllerFor("plans"),
      });
    },

    openDeletePlanModal : function(model){
      self.renderModal("delete_plan", {
        model: model,
        parent: this.controllerFor("plans"),
      });
    },

    openEditPlanModal : function(model){
      var self = this;
      model.getPlanRecordsSync(function(){
        self.renderModal("edit_plan", {
          model: model,
          job: self.get("controller").get("model"),
          parent: this.controllerFor("plans"),
        });
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
      self.renderModal("sub_share_link", {
        model: this.get("controller").get("model"),
        parent: this.controllerFor("plans"),
      });
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
