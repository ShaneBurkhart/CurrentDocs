PlanSource.PlansController = Ember.ArrayController.extend({
	sortProperties: ['planNum'],
  sortAscending: true,

  addPlan : function(plan){
  	var self = this;
		this.get("content").pushObject(plan);
		plan.save().then(function(data){
      if(data == false)
        self.get("content").removeObject(plan);
    });
	},

	removePlan : function(plan){

	}
});