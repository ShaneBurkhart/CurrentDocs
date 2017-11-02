PlanSource.JobRfiAsiRoute = Ember.Route.extend({
  tab: 'ASI',

  setupController: function (controller) {
    var jobController = this.controllerFor('job');
    var job = jobController.get('model');

    jobController.set('currentTab', this.tab);
    controller.set('jobController', jobController);
    controller.set('content', job.getFilteredRFIsAndASIs('open'));
  }
});

