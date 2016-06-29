PlanSource.JobController = Ember.ObjectController.extend({
  tab: 'Plans',


  changeTab: function(tab) {
    this.set('tab', tab);
  },

  isPlansTab: function() {
    return this.get('tab') === 'Plans';
  }.property('tab'),

  isShopsTab: function() {
    return this.get('tab') === 'Shops';
  }.property('tab'),

  isConsultantsTab: function() {
    return this.get('tab') === 'Consultants';
  }.property('tab'),

  isCalcTab: function() {
    return this.get('tab') === 'Calcs & Misc';
  }.property('tab'),

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
