PlanSource.ContactListController = Ember.ArrayController.extend({

  needs : ["share_job"],
  sortProperties : ['first_name'],
  sortAscending : true,

  shareWithContacts : function(){
    var button = $("#contact-share");
    button.bind("click", false);
    var shareBoxes = $("#contacts-list").find(".share-box");
    var canReshareBoxes = $("#contacts-list").find(".can-reshare-box");
    var shares = [];
    var self = this;

    shareBoxes.each(function(index, box){
      var b = $(box);
      var id = b.data("id");
      var share = {
        checked: b.is(":checked"),
        user_id: id,
        job_id: self.get("job.id"),
        can_reshare: false
      };

      canReshareBoxes.each(function(index, reshareBox) {
        var canReshareBox = $(reshareBox);
        var reshareId = canReshareBox.data("id");
        if(id === reshareId) {
          share["can_reshare"] = canReshareBox.is(":checked");
        }
      });

      shares.push(share);
    });

    console.log(shares);

    $.post("/api/shares/batch", {
        "job_id" : self.get("job.id"),
        "shares" : shares
      },
      function(data){
        self.set("job.shares", []);
        if(data.shares){
          for(var i = 0 ; i < data.shares.length ; i ++)
            self.get("job.shares").push(PlanSource.Share.create(data.shares[i]));
        }
        self.send("close");
        button.bind("click", true);
      },
      "json"
    );
  },

  changeSort : function(sorter){
    this.set("sortProperties", [sorter]);
  },

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


PlanSource.ContactController = Ember.ObjectController.extend({
  needs : ["contact_list"],

  isSharedChecked: function(){
    var shares = this.get("controllers.contact_list.job.shares");
    for(var i = 0 ; i < shares.length ; i ++){
      if(this.get("model.id") == shares[i].get("user.id"))
        return "checked";
    }
    return "";
  }.property(),

  canResharedChecked: function(){
    var shares = this.get("controllers.contact_list.job.shares");
    for(var i = 0 ; i < shares.length ; i ++){
      if(this.get("model.id") == shares[i].get("user.id"))
        return shares[i].get("can_reshare") ? "checked" : "";
    }
    return "";
  }.property()
});
