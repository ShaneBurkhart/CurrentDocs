PlanSource.SubmittalController = PlanSource.ModalController.extend({
  // 3 states: new, review, and view
  // new - no model
  // review - model exists but is in review
  // view - model exists and is not in review

  isNew: function () {
    return !this.get("model").get("id");
  }.property(),

  isInReview: function () {
    var submittal = this.get("model");
    return submittal && !submittal.get("is_accepted");
  }.property(),

  isAccepted: function () {
    return !this.get("isInReview");
  }.property(),

  shopPlans: function () {
    return this.get("job").getPlansByTab('Shops');
  }.property("job"),

  submitSubmittal: function () {
    var self = this;
    var submittal = this.get("model");
    var data = this.getSubmittalData();

    submittal.set("data", data);
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

        PlanSource.showNotification("Submittal accepted!");
        self.send("close");
      } else if (submittal && !submittal.get("is_accepted")) {
        // Update submittal after saving
        //
        PlanSource.showNotification("Submittal updated!");
        self.send("close");
      } else {
        // Error
        PlanSource.showNotification("There was a problem. Try again later!", "error");
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

	keyPress : function(e){
		if (e.keyCode == 27){
			this.send('close');
		}
	}
});
