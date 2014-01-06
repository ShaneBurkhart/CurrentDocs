PlanSource.ContactListController = Ember.ArrayController.extend({

  sortProperties : ['email'],
  sortAscending : true,

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
        if(data.contact && data.contact.id){
          self.get("content").pushObject(PlanSource.Contact.create(data.contact.contact));
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
  },

  error : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
        cont = text.parent().parent();
    cont.addClass("error");
    text.text(msg);
  },

  clearError : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
        cont = text.parent().parent();
    cont.removeClass("error");
    text.text("");
  },

  clearAllErrors : function(){
    var errors = $(".control-group").find("controls").find(".help-inline");
    errors.each(function(e){
      e.text("");
    });
    $(".control-group").removeClass("error");
  },

  info : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
      cont = text.parent().parent();
    cont.addClass("info");
    text.text(msg);
  },

  clearInfo : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
      cont = text.parent().parent();
    cont.removeClass("info");
    text.text("");
  },

  clearAllInfo : function(){
    var infos = $(".control-group").find("controls").find(".help-inline");
    infos.each(function(info){
      info.text("");
    });
    $(".control-group").removeClass("info");
  }

});

