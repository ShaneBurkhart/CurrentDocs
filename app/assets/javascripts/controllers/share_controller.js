PlanSource.ShareController = Ember.ObjectController.extend({

  editCanShare : function(){
    var share = this.get("model");
    share.set("can_reshare", !share.get("can_reshare"));
    share.save();
  },

  deleteShare : function(){
  	var share = this.get("model");
  	this.send("removeShare", share);
  	share.deleteRecord();
  	share.save();
  }

});