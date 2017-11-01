PlanSource.JobPlansRoute = Ember.Route.extend({
  tab: 'Plans',

  setupController: function (controller) {
    var jobController = this.controllerFor('job');
    var job = jobController.get('model');

    controller.set('jobController', jobController);
    controller.set('content', job.getPlansByTab(this.tab));
  },

  renderTemplate: function (controller) {
    this.render('job/plans', { controller: controller });
  }
});

PlanSource.JobAddendumsRoute = PlanSource.JobPlansRoute.extend({ tab: 'Addendums' });
PlanSource.JobSupportRoute = PlanSource.JobPlansRoute.extend({ tab: 'Consultants' });
PlanSource.JobCalcsRoute = PlanSource.JobPlansRoute.extend({ tab: 'Calcs & Misc' });
