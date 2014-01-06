PlanSource.ContactListController = PlanSource.ModalController.extend({

  addContact: function(){
    var self = this;
    var container = $("#contact-email"),
    email = container.val();
    this.clearAllErrors();
    this.clearAllInfo();
    if(!email || email == "" || !email.match(/^\S+@\S+\.\S+$/)){
      this.error("#contact-email", "Not a valid email.");
      return;
    }
    $.post("/api/user/contacts", {
      "contact" : {"email" : email}
      },
      function(data){
        console.log(data.contact.contact);
        if(data.contact && data.contact.id){
          self.get("contacts").pushObject(PlanSource.Contact.create(data.contact.contact));
          self.info("#contact-email", "Succesfully added contact.");
        }else{
          if(data.error)
            self.error("#contact-email", data.error);
          else
            self.error("#contact-email", "An error occured when adding contact");
        }
      },
      "json"
    );
    container.val("");
  },

  numShares : function(){
    var num = 0;
    return this.get("contacts").length
  }.property("contacts.@each"),

  keyPress : function(e){
    if (e.keyCode == 13)
      this.addContact();
  }

});
