PlanSource.SubmittalController = PlanSource.ModalController.extend({
  // 3 states: new, review, and view
  // new - no model
  // review - model exists but is in review
  // view - model exists and is not in review

  // The errors for the submittal form.
  errors: {},

  isNew: function () {
    return !this.get("model").get("id");
  }.property("id"),

  isInReview: function () {
    var submittal = this.get("model");
    return !this.get("isNew") && !submittal.get("is_accepted");
  }.property("model", "is_accepted", "isNew"),

  isAccepted: function () {
    return !this.get("isInReview");
  }.property("isInReview"),

  shopPlans: function () {
    return this.get("job").getPlansByTab('Shops');
  }.property("job"),

  submitSubmittal: function () {
    var self = this;
    var submittal = this.get("model");
    var data = this.getSubmittalData();
    var attachments = this.getAttachments();

    submittal.set("data", data);
    submittal.set("attachments", attachments);
    submittal.submit(function (submittal) {
      if (submittal) {
        var job = self.get("job");
        var submittals = job.get("submittals");

        // Add submittal to job submittals
        submittals.push(submittal);
        job.set("submittals", submittals);

        PlanSource.showNotification("Thanks! Your shop drawing has been submitted.");
        self.send("close");
      } else {
        // Error
        PlanSource.showNotification("There was a problem. Try again later!", "error");
      }
    });
  },

  updateSubmittal: function (shouldAccept) {
    var self = this;
    var submittal = this.get("model");
    var data = this.getSubmittalData();
    var planId = $("#submittal-job-id").val();

    submittal.set("data", data);
    submittal.set("plan_id", planId);
    submittal.set("is_accepted", shouldAccept);

    var errors = submittal.validate();
    this.set("errors", errors);
    if (errors) {
      submittal.set("is_accepted", false);
      return;
    }

    submittal.save(function (submittal) {
      if (submittal && submittal.get("is_accepted")) {
        // Don't need to add submittal to plan since opening the plan details
        // modal retches approved submittals for that plan.
        // We do have to remove the submittal from the job though.
        var job = self.get("job");
        var purgedSubmittals = job.get("submittals").reduce(function (subs, sub) {
          if (sub.get("id") !== submittal.get("id")) subs.push(sub);
          return subs;
        }, []);
        job.set("submittals", purgedSubmittals);

        self.send("close");
      } else if (submittal && !submittal.get("is_accepted")) {
        self.send("close");
      } else {
        // Error
      }
    });
  },

  getSubmittalData: function () {
    return {
      csi_code:  $("#submittal-csi-code").val(),
      description: $("#submittal-description").val(),
      notes: $("#submittal-notes").val(),
    };
  },

  getAttachments: function () {
    var attachments = [];
    var $attachments = $(".file-preview");

    $attachments.each(function (i, el) {
      attachments.push($(el).attr("data-id"));
    });

    return attachments;
  },

	keyPress : function(e){
		if (e.keyCode == 27){
			this.send('close');
		}
	}
});
