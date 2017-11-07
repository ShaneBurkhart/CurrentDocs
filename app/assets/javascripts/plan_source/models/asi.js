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
    return this.get('rfi');
  }.property('rfi'),

  rfi_num: function () {
    return null;
  }.property(),

  dateSubmitted: function () {
		return moment(this.get("created_at")).format("LL");
  }.property('created_at'),

  submittedBy: function () {
		return this.get('user.first_name') + " " + this.get('user.last_name');
  }.property('user'),

  assignedTo: function () {
    if (!this.get('assigned_user')) return null;

		return this.get('assigned_user.first_name') + " " + this.get('assigned_user.last_name');
  }.property('assigned_user'),
});

