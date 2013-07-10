PlanSource.Job = DS.Model.extend({
	name : DS.attr("string"),
	user : DS.belongsTo("PlanSource.User"),
	plans : DS.hasMany("PlanSource.Plan"),
	shares : DS.hasMany("PlanSource.Share"),

	becameInvalid : function(data){
		this.deleteRecord();
  }
});