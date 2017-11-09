PlanSource.JobShopsRoute = Ember.Route.extend({
  tab: 'Shops',

  setupController: function (controller) {
    var jobController = this.controllerFor('job');
    var job = jobController.get('model');

    jobController.set('currentTab', this.tab);
    controller.set('jobController', jobController);
    controller.set('content', job.getPlansByTab(this.tab));
  }
});

