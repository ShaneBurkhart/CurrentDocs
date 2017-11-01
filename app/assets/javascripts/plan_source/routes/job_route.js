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
        parent: this.controllerFor("job"),
      });
    },

    openUploadPlanModal : function(model){
      this.renderModal("upload_plan", {
        model: model,
        parent: this.controllerFor("job"),
      });
    },

    openDeletePlanModal : function(model){
      this.renderModal("delete_plan", {
        model: model,
        parent: this.controllerFor("job"),
      });
    },

    openEditPlanModal : function(model){
      var self = this;
      model.getPlanRecordsSync(function(){
        self.renderModal("edit_plan", {
          model: model,
          job: self.get("controller").get("model"),
          parent: self.controllerFor("job"),
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
            parent: self.controllerFor("job"),
          });
        });
      });
    },

    openSubShareLinkModal: function(){
      this.renderModal("sub_share_link", {
        model: this.get("controller").get("model"),
        parent: this.controllerFor("job"),
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
        parent: this.controllerFor("job"),
      });
    },

    openAddReportModal: function() {
      // Not implementing yet ;)
      //var job = this.get("controller").get("model");

      //this.renderModal("submittal_list", { model: job });
    },

    openUploadPhotosModal: function() {
      this.renderModal("upload_photos", {
        model: this.get("controller").get("model"),
        parent: this.controllerFor("job"),
      });
    },

    openEditPhotoModal: function(photo) {
      this.renderModal("edit_photo", {
        model: photo,
        parent: this.controllerFor("job"),
      });
    },

    openDeletePhotoModal: function(photo) {
      this.renderModal("delete_photo", {
        model: photo,
        parent: this.controllerFor("job"),
      });
    },

    openSubmittalListModal: function() {
      var job = this.get("controller").get("model");

      this.renderModal("submittal_list", { model: job });
    }
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

  clearOutlet: function(container, outlet) {
    parentView = this.router._lookupActiveView(container);
    parentView.disconnectOutlet(outlet);
  },

  model : function(param){
    return PlanSource.Job.find(param.job_id);
  }
});
