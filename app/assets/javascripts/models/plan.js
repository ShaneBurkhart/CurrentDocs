PlanSource.Plan = DS.Model.extend({
	pageName : DS.attr("string"),
	filename : DS.attr("string"),
	job : DS.belongsTo("PlanSource.Job")
});