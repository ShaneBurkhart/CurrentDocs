PlanSource.ShareController = Ember.ObjectController.extend({

  deleteShare : function(){
  	this.get("model").deleteRecord();
  	this.get("model").save();
  }

});