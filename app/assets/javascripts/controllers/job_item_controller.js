PlanSource.JobItemController = Ember.ObjectController.extend({

	delete : function(){
		var job = this.get('model');
	  job.deleteRecord();
	  job.save();
	},

	isMe : function(me){
		return this.get('model').get('user').get('name') == user
	},

	isEditing : false,

	edit : function(){
		this.set("isEditing", true);
	}, 

	doneEditing : function(){
		this.set("isEditing", false);
		this.get("model").save();
	},

	keyPress: function(e){
		console.log("Test");
		var code = (e.keyCode ? e.keyCode : e.which);
	  if (this.get("isEditing") && code == 13)
			this.doneEditing(e);
	}
	
});