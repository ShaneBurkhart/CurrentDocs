PlanSource.JobRoute = Ember.Route.extend({
  // Modal stack so we can open modals while in modals and come back.
  _modalStack: [],

  events : {
    close : function(){
      this.closeModal();
    },

    openAddPlanModal : function(){
      this.renderModal("add_plan", {
        model: this.get("controller").get("model"),
        parent: this.controllerFor("plans"),
      });
    },

    openUploadPlanModal : function(model){
      this.renderModal("upload_plan", {
        model: model,
        parent: this.controllerFor("plans"),
      });
    },

    openDeletePlanModal : function(model){
      this.renderModal("delete_plan", {
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
          parent: self.controllerFor("plans"),
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
      this.renderModal("sub_share_link", {
        model: this.get("controller").get("model"),
        parent: this.controllerFor("plans"),
      });
    },

    openSubmittalModal: function(submittal) {
      var job = this.get("controller").get("model");
      // Create Submittal if doesn't exist. No submittal means new submittal modal.
      // Only need job for project name.
      var submittal = submittal || PlanSource.Submittal.create({ job: job });

      this.renderModal("submittal", {
        model: submittal,
        job: job,
      });
    },

    openSubmittalListModal: function() {
      var job = this.get("controller").get("model");

      this.renderModal("submittal_list", { model: job });
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
    var modalController = this.controllerFor(modal);
    // Make sure outlet is clear before rendering. Previous modal is saved to stack.
    this.clearOutlet("jobs", "modal");

    modalController.setProperties(attrs);
    this.render("modals/" + modal, {into : "jobs", outlet : "modal", controller : modal});
    if (modalController.onOpen) modalController.onOpen();

    this._modalStack.push(modal);
  },

  closeModal: function () {
    var currentModal = this._modalStack.pop();
    var currentModalController = this.controllerFor(currentModal);
    // Let the modal clean up
    if (currentModalController.onClose) currentModalController.onClose();

    // Clear modal
    this.clearOutlet('jobs', 'modal');

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
