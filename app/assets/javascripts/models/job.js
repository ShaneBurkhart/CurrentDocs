PlanSource.Job = DS.Model.extend({
	name : DS.attr("string"),
	user : DS.belongsTo("PlanSource.User", {embedded : "load"}),
	plans : DS.hasMany("PlanSource.Plan", {embedded : "load"}),
	shares : DS.hasMany("PlanSource.Share", {embedded : "load"})
});