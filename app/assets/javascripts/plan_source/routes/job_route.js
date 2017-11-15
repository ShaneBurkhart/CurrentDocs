PlanSource.JobRoute = Ember.Route.extend({
  // Modal stack so we can open modals while in modals and come back.
  _modalStack: [],

  events : {
    close : function(){
      this.closeModal();
    },

    openAddPlanModal : function(){
      var jobController = this.get("controller");

      this.renderModal("add_plan", {
        model: jobController.get("model"),
        parent: jobController,
        tab: jobController.get('currentTab'),
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
      var jobController = this.get("controller");
      var self = this;

      model.getPlanRecordsSync(function(){
        self.renderModal("edit_plan", {
          model: model,
          job: jobController.get("model"),
          parent: jobController,
          tab: jobController.get('currentTab'),
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
    },

    openCreateRfiModal: function () {
      this.renderModal("rfi_asi", {
        model: PlanSource.RFI.create(),
        parent: this.controllerFor("job"),
      });
    },

    openCreateUnlinkedAsiModal: function () {
      this.renderModal("rfi_asi", {
        model: PlanSource.ASI.create(),
        parent: this.controllerFor("job"),
      });
    },

    openRfiAsiModal: function (rfiOrAsi) {
      this.renderModal("rfi_asi", {
        model: rfiOrAsi,
        parent: this.controllerFor("job"),
      });
    },

    openProjectManagerModal: function () {
      var jobController = this.controllerFor("job");
      var job = jobController.get('model');

      this.renderModal("project_manager", {
        content: job.getEligibleProjectManagers(),
        projectManager: jobController.get("model.project_manager"),
        parent: jobController,
      });
    },

    openAssignRFIModal: function (rfi_asi) {
      var jobController = this.controllerFor("job");
      var job = jobController.get('model');

      this.renderModal("assign_rfi", {
        // Right now, anyone shared with the Plans tab can be a project
        // manager or be assigned to an RFI.  Using getEligibleProjectManagers()
        // so we don't have to duplicate the route until logic changes.
        content: job.getEligibleProjectManagers(),
        rfiAsi: rfi_asi,
        parent: jobController,
      });
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

    // Prevent scrolling of the page when modal is open
    document.body.style.overflow = 'hidden';
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
    } else {
      // Restore scrolling when no modals are remaining
      document.body.style.overflow = 'visible';
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
