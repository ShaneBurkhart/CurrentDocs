var isFilterProp = function (filter) {
  return function () { return this.isFilter(filter); }.property('currentFilter');
};

PlanSource.JobRfiAsiController = PlanSource.ArrayController.extend({
  tab: 'ASI',
	sortProperties: ['status'],
  sortAscending: false,
  currentFilter: 'open',

  filter: function (filter) {
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

  isFilter: function (filter) {
    return filter === this.get('currentFilter');
  },

  isOpenFilter: isFilterProp('open'),
  isClosedFilter: isFilterProp('closed'),
  isAllFilter: isFilterProp('all'),
  isMeFilter: isFilterProp('me')
});

