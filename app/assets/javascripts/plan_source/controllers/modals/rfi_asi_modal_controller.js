PlanSource.RfiAsiController = PlanSource.ModalController.extend({
  submitRFI: function () {
    var self = this;
    var rfi = this.get("model");
    var data = this.getRFIData();
    var attachments = this.getRFIAttachments();
    var job = this.get("parent.model");

    rfi.setProperties(data);
    rfi.set("job_id", job.get("id"));
    rfi.set("attachment_ids", attachments);

    var errors = rfi.validate();
    this.set("errors", errors);
    if (errors) return;

    rfi.submit(function (rfi) {
      if (rfi) {
        job.get('rfis').pushObject(rfi);
        toastr.success("Submitted, thanks!");
        self.send("close");
      } else {
        // Error
        toastr.error("Sorry, try again later!", "error");
      }
    });
  },

  addASI: function () {
    this.get("model").set("asi", PlanSource.ASI.create());
  },

  getRFIData: function () {
    return {
      subject:  $("#rfi-subject").val(),
      notes: $("#rfi-notes").val(),
    };
  },

  getRFIAttachments: function () {
    return this.getAttachments("#rfi-attachments");
  },

  getASIAttachments: function () {
    return this.getAttachments("#asi-attachments");
  },

  getAttachments: function (id) {
    var id = id || "";
    var attachments = [];
    var $attachments = $(id + " .file-preview");

    $attachments.each(function (i, el) {
      attachments.push($(el).attr("data-id"));
    });

    return attachments;
  },

	keyPress: function(e) {
		if (e.keyCode == 13) {
      if (this.get('model.isNew')) {
        this.submitRFI();
      } else {
        this.updateRFI();
      }
    }
	}
});

