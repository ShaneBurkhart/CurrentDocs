PlanSource.JobPlansController = PlanSource.ArrayController.extend({
  tab: 'Plans',
	sortProperties: ['plan_num'],
  sortAscending: true,

  updatePlans: function () {
    var job = this.get('jobController.model');

    this.set('content', job.getPlansByTab(this.tab));
  }.observes(
    'jobController.model',
    'jobController.model.plans',
    'jobController.model.plans.@each',
    // Watching id is the same as watching for save
    'jobController.model.plans.@each.id'
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

PlanSource.JobShopsController = PlanSource.JobPlansController.extend({
  tab: 'Shops'
});