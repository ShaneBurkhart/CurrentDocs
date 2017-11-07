PlanSource.ProjectManagerController = Ember.ArrayController.extend({
  sortProperties: ['first_name'],
  sortAscending: true,

  sort: function(sorter){
    this.set("sortProperties", [sorter]);
  },

  selectContact: function (contact) {
    var self = this;
    var job = this.get("parent.model");

    $.post("/api/jobs/" + job.id + "/project_manager", {
      project_manager_user_id: contact.id,
    }, function (data) {
      if (data.project_manager) {
        job.set("project_manager", data.project_manager)

        toastr["success"]("Succesfully updated project manager!");

        self.send('close');
      } else {
        toastr["error"]("The email '" + email + "' already exists or is invalid.")
      }
    }, "json");
  },

  addContact: function(){
    var self = this;
    var container = $("#contact-email");
    var email = container.val().trim();

    if(!email || email == "" || !email.match(/^\S+@\S+\.\S+$/)) return;

    $.post("/api/user/contacts", {
      contact: { email: email }
    }, function (data) {
      if (data.contact && data.contact.id) {
        self.get("content").pushObject(
          PlanSource.Contact.create(data.contact.contact)
        );

        toastr["success"]("Succesfully added contact. " +
          "Sent email with share details to " + email);
      } else {
        toastr["error"]("The email '" + email + "' already exists or is invalid.")
      }
    }, "json");

    container.val("");
  },

  keyPress : function(e){
    if (e.keyCode == 13)
      this.addContact();
  }
});
