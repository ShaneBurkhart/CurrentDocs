PlanSource.User = DS.Model.extend({
	firstName : DS.attr("string"),
	lastName : DS.attr("string"),
	email : DS.attr("string"),
	jobs : DS.hasMany("PlanSource.Job"),

	fullName : function(){
		return this.get("firstName") + " " + this.get("lastName");
	}.property("firstName", "lastName")
});