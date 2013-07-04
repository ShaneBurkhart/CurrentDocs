PlanSource.Plan = DS.Model.extend({
	planNum : DS.attr("number"),
	planName : DS.attr("string"),
	filename : DS.attr("string"),
	job : DS.belongsTo("PlanSource.Job"),
	updatedAt : DS.attr("date")
});