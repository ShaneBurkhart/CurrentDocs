PlanSource.TextField = Ember.TextField.extend({

	attributeBindings : ["placeholder", "value"],

	didInsertElement : function(){
		var placeholder = this.get("placeholder");
		if(placeholder)
			this.set("placeholder", placeholder);
		if(this.get("focus"))
			this.$().focus();
		if(this.get("modelAttr"))
			this.set("value", this.get("controller").get("model").get(this.get("modelAttr")))
	},

	keyPress : function(e){
		this.get("controller").keyPress(e);
	}

});