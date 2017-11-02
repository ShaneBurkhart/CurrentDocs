PlanSource.ASI = Ember.Object.extend({
  asi_id: function () {
    return this.get('id');
  }.property('id'),
});

