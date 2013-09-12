PlanSource.User = Ember.Object.extend({

  fullName : function(){
    return this.get("first_name") + " " + this.get("last_name");
  }.property("first_name", "last_name"),

  isManager : function(){
    return PlanSource._user_type == "Manager"
  }.property()

});