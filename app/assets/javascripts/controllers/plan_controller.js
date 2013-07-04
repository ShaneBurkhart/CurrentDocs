PlanSource.PlanController = Ember.ObjectController.extend({

	upload : function(event){
		var id = this.get("model").get("id");
		$("#plan_id").val(id);
		$("#file").trigger("click");
	},

	addObserver : false,

	doneEditing : function(){
		this.set("isEditing", false);
		var o = this.get("model"), self = this;
		if(!this.get("addObserver")){
			o.on('didUpdate', function() {
  			self.get("model").get("job").reload();
			});
			this.set("addObserver", true);
		}
		o.save();
	},

	keyPress: function(e){
		console.log("Test");
		var code = (e.keyCode ? e.keyCode : e.which);
	  if (this.get("isEditing") && code == 13)
			this.doneEditing(e);
	}

});