PlanSource.Share = DS.Model.extend({
	user : DS.belongsTo("PlanSource.User"),
	job : DS.belongsTo("PlanSource.Job")
});