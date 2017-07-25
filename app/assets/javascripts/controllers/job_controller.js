PlanSource.JobController = Ember.ObjectController.extend({
  tab: 'Plans',

  changeTab: function(tab) {
    this.set('tab', tab);
  },

  isPlansTab: function() {
    return this.get('tab') === 'Plans';
  }.property('tab'),

  isAddendumsTab: function() {
    return this.get('tab') === 'Addendums';
  }.property('tab'),

  isShopsTab: function() {
    return this.get('tab') === 'Shops';
  }.property('tab'),

  isConsultantsTab: function() {
    return this.get('tab') === 'Consultants';
  }.property('tab'),

  isASITab: function() {
    return this.get('tab') === 'ASI';
  }.property('tab'),

  isCalcTab: function() {
    return this.get('tab') === 'Calcs & Misc';
  }.property('tab'),

  submittalCount: function () {
    return this.get('model').get('submittals').length;
  }.property('model.submittals'),

  archiveJob: function() {
    this.get('model').set('archived', true);
    this.get('model').save();
  },
  unarchiveJob: function() {
    this.get('model').set('archived', false);
    this.get('model').save();
  },

  subscribeJob:function(){
    this.get('model').set('subscribed', true);
    this.get('model').save();
  },
  unsubscribeJob:function(){
    this.get('model').set('subscribed', false);
    this.get('model').save();
  },

	back : function(){
		window.history.go(-1);
	}
});
