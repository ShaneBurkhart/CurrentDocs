PlanSource.ShareController = Ember.ObjectController.extend({

  deleteShare : function(){
  	var share = this.get("model");
  	this.send("removeShare", share);
  	share.deleteRecord();
  	share.save();
  }

});