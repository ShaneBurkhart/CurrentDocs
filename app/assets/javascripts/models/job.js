PlanSource.Job = DS.Model.extend({
	name : DS.attr("string"),
	user : DS.belongsTo("PlanSource.User"),
	plans : DS.hasMany("PlanSource.Plan")
});