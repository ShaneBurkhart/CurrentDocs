PlanSource.User = Ember.Object.extend({

	full_name : function(){
		return this.get("first_name") + " " + this.get("last_name");
	}.property("first_name", "last_name")

});