PlanSource.User = DS.Model.extend({
	name : DS.attr("string"),
	email : DS.attr("string"),
	jobs : DS.hasMany("PlanSource.Job")
});