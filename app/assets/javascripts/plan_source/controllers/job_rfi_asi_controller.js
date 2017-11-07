var isFilterProp = function (filter) {
  return function () { return this.isFilter(filter); }.property('currentFilter');
};

PlanSource.JobRfiAsiController = PlanSource.ArrayController.extend({
  tab: 'ASI',
	sortProperties: ['status', 'rfi_num', 'asi_num'],
  sortAscending: false,
  currentFilter: 'open',

  filter: function (filter) {
    // Reset filters to the default when going with a preset filter.
    this.set('sortProperties', ['status', 'rfi_num', 'asi_num'])
    this.set('currentFilter', filter);
  },

  // When photos change, we need to update content here.
  updatePlans: function () {
    var job = this.get('jobController.model');

    this.set('content', job.getFilteredRFIsAndASIs(this.get('currentFilter')));
  }.observes(
    'currentFilter',
    'jobController.model',
    'jobController.model.rfis',
    'jobController.model.rfis.@each',
    'jobController.model.rfis.@each.id',
    'jobController.model.asis',
    'jobController.model.asis.@each',
    'jobController.model.asis.@each.id'
  ),

  projectManager: function () {
    return this.get('jobController.model.project_manager')
  }.property("jobController.model.project_manager"),

  isFilter: function (filter) {
    return filter === this.get('currentFilter');
  },

  isOpenFilter: isFilterProp('open'),
  isClosedFilter: isFilterProp('closed'),
  isAllFilter: isFilterProp('all'),
  isMeFilter: isFilterProp('me')
});

