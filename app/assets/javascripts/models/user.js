PlanSource.User = Ember.Object.extend({

	fullName : function(){
		return this.get("firstName") + " " + this.get("lastName");
	}.property("firstName", "lastName")

});