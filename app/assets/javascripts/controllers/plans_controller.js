PlanSource.PlansController = Ember.ArrayController.extend({

  needs: ['job'],
	sortProperties: ['plan_num'],
  sortAscending: true,

  sort: function(sortProperty){
    if (sortProperty == this.sortProperties[0]){
      if (this.sortAscending == true){
        this.set("sortAscending", false);
      }
      else{
        this.set("sortAscending", true);
      }
    }else{
      this.set("sortAscending", true);
    }
    this.set('sortProperties', [sortProperty]);
  },

  addPlan : function(plan){
  	if(this.planExists(plan)) return false;
  	var self = this;
		this.get("controllers.job.model.plans").pushObject(plan);
    this.updateTab();

		plan.save().then(function(data){
      if(data == false) {
        self.get("controller.job.model.plans").removeObject(plan);
        this.updateTab();
      }
    });
    return true;
	},

	removePlan : function(plan){
		var self = this;
		this.get("controllers.job.model.plans").removeObject(plan);
    this.updateTab();
		plan.deleteRecord();
		plan.save().then(function(){
			self.updatePlans();
		});
	},

	updatePlans : function(){
		var self = this;
		PlanSource.Job.find(this.get("job").get("id")).then(function(job){
			self.set("controllers.job.model", job);
      self.updateTab();
		});
	},

	planExists : function(new_plan){
		var name;
		if (typeof new_plan == 'string' || new_plan instanceof String)
			name = new_plan;
		else
			name = new_plan.get("plan_name");
    for(var i = 0 ; i < this.get("content").length ; i++){
      var plan = this.get("content")[i];
      if(plan.get("plan_name") == name)
        return true;
    }
    return false;
  },

  updateTab: function() {
    var jobController = this.get('controllers.job');
    var job = jobController.get('model');
    var tab = jobController.get('tab');
    var self = this;

    if (tab === "Photos") {
      job.getPhotos(function (photos) {
        self.set('content', photos);
      });
    } else {
      this.set('content', job.getPlansByTab(tab));
    }

    if(tab == 'Shops') {
      this.set('sortProperties', ['csi']);
    } else if (tab == 'Photos') {
      this.set('sortProperties', ['date_taken', 'created_at', 'id']);
      this.set("sortAscending", false);
    } else {
      this.set('sortProperties', ['plan_num']);
    }
  }.observes('controllers.job.tab')
});
