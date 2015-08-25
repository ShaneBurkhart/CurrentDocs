PlanSource.JobController = Ember.ObjectController.extend({
  archiveJob: function() {
    this.get('model').set('archived', true);
    this.get('model').save();
  },

  unarchiveJob: function() {
    this.get('model').set('archived', false);
    this.get('model').save();
  },

	back : function(){
		window.history.go(-1);
	}
});
