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

  asi_id: function () {
    return this.get('id');
  }.property('id'),
});

