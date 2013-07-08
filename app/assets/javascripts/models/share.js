PlanSource.Share = DS.Model.extend({
	user : DS.belongsTo("PlanSource.User", {embedded : "load"}),
	job : DS.belongsTo("PlanSource.Job", {embedded : "load"})
});