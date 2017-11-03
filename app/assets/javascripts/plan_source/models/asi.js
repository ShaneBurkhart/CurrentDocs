PlanSource.ASI = Ember.Object.extend({
  isNew: function () {
    return !this.get('id');
  }.property('id'),

  isOpen: function () {
    return this.get('status') === 'Open';
  }.property('status'),

  getASI: function () {
    return this;
  }.property(),

  getRFI: function () {
    return null;
  }.property(),

  rfi_num: function () {
    return null;
  }.property(),

  dateSubmitted: function () {
		return moment(this.get("created_at")).format("LL");
  }.property('created_at')
});

