PlanSource.JobsIndexRoute = Ember.Route.extend({
  events : {
    close : function(){
      this.render("nothing", {into : "jobs", outlet : "modal"});
    },

    openAddJobModal : function(){
      this.controllerFor("add_job").set("parent", this.get("controller"));
      this.render("modals/add_job", {into : "jobs", outlet : "modal", controller : "add_job"});
    },

    openShareJobModal : function(model){
      if(model)
        this.controllerFor("share_job").set("model", model);
      this.controllerFor("share_job").set("parent", this.get("controller"));
      this.render("modals/share_job", {into : "jobs", outlet : "modal", controller : "share_job"});
    },

    openContactModal: function(){
      this.controllerFor("contact_list").set("model", PlanSource.Contact.findAll());
      this.render("modals/contact_list", {into : "jobs", outlet : "modal", controller : "contact_list"});
    },

    openDeleteJobModal : function(model){
      this.controllerFor("delete_job").set("model", model);
      this.controllerFor("delete_job").set("parent", this.get("controller"));
      this.render("modals/delete_job", {into : "jobs", outlet : "modal", controller : "delete_job"});
    },

    openEditJobModal : function(model){
      this.controllerFor("edit_job").set("model", model);
      this.controllerFor("edit_job").set("parent", this.get("controller"));
      this.render("modals/edit_job", {into : "jobs", outlet : "modal", controller : "edit_job"});
    },

    openUnshareJobModal : function(model){
      this.controllerFor("unshare_job").set("model", model);
      this.controllerFor("unshare_job").set("parent", this.get("controller"));
      this.render("modals/unshare_job", {into : "jobs", outlet : "modal", controller : "unshare_job"});
    }
  },

  model : function(){
    return PlanSource.Job.findAll();
  }

});
