PlanSource.User = Ember.Object.extend({

  fullName : function(){
    return this.get("first_name") + " " + this.get("last_name");
  }.property("first_name", "last_name"),

  isManager : function(){
    return PlanSource._user_type == "Manager"
  }.property()

});

PlanSource.Contact = Ember.Object.extend({

});

PlanSource.Contact.reopenClass({
  baseUrl : "/api/user/contacts",

  url : function(){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = "http://" + host + PlanSource.Contact.baseUrl;
    return u;
  },

  findAll : function(){
    var users = Ember.Object.create();
    $.get(PlanSource.Contact.url()).then(function(data){
      users.set("contacts", data.users);
      return true;
    });
    return users;
  }

});
