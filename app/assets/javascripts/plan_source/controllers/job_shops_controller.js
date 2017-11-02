PlanSource.JobShopsController = PlanSource.ArrayController.extend({
  tab: 'Shops',
	sortProperties: ['plan_num'],
  sortAscending: true,

  updatePlans: function () {
    var job = this.get('jobController.model');

    this.set('content', job.getPlansByTab(this.tab));
  }.observes(
    'jobController.model',
    'jobController.model.plans',
    'jobController.model.plans.@each'
  )
});

PlanSource.JobAddendumsController = PlanSource.JobPlansController.extend({
  tab: 'Addendums'
});

PlanSource.JobSupportController = PlanSource.JobPlansController.extend({
  tab: 'Consultants'
});

PlanSource.JobCalcsController = PlanSource.JobPlansController.extend({
  tab: 'Calcs & Misc'
});

