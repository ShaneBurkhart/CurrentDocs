PlanSource.ContactListController = PlanSource.ModalController.extend({

  shareJob : function(){
    var self = this;
    var container = $("#share-email"),
    email = container.val();
    this.clearAllErrors();
    this.clearAllInfo();
    if(!email || email == "" || !email.match(/^\S+@\S+\.\S+$/)){
      this.error("#share-email", "Not a valid email.");
      return;
    }
    $.post("/api/shares", {
      "share" : {"job_id" : this.get("model").get("id"), "email" : email}
      },
      function(data){
        if(data.share && data.share.id){
          self.get("shares").pushObject(PlanSource.Share.create(data.share));
          self.get("parent").updateJobs();
          self.info("#share-email", "Succesfully shared with " + data.share.user.email);
        }else{
          if(data.error)
            self.error("#share-email", data.error);
          else
            self.error("#share-email", "An error occured when sharing with " + email);
        }
      },
      "json"
    );
    container.val("");
  },

  removeShare : function(share){
    this.get("model").get("shares").removeObject(share);
  },

  keyPress : function(e){
    if (e.keyCode == 13)
      this.shareJob();
  }

});
