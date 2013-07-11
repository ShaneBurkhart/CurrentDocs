PlanSource.Job = DS.Model.extend({
	name : DS.attr("string"),
	user : DS.belongsTo("PlanSource.User"),
	plans : DS.hasMany("PlanSource.Plan"),
	shares : DS.hasMany("PlanSource.Share"),

	username : function(){
		if(this.get("user"))
    	return this.get('user').get('id') == user_id ? "Me" : this.get("user").get("fullName");
    else
    	return "";
	}.property('user'),

	isShared : function(){
  	if(this.get("user"))
  		return this.get("user").get("id") != user_id;
  	else
  		return false;
  }.property("user"),

  sorter : function(){ //either a 1 or 0 depending on isShared. Its for order
  	return this.get("isShared") == false ? 0 : 1;
  }.property("isShared"),

	becameInvalid : function(data){
		this.deleteRecord();
  }
});