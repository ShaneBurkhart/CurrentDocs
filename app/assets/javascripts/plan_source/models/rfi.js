PlanSource.RFI = Ember.Object.extend({
  init : function() {
    this.setProperties(this.getProperties('asi'));
  },

  setProperties : function(hash) {
    if(hash.asi){
      this.set('asi', PlanSource.ASI.create(hash.asi));
      delete hash.asi
    }

    Ember.setProperties(this, hash);
  },

  isNew: function () {
    return !this.get('id');
  }.property('id'),

  isOpen: function () {
    return this.get('status') === 'Open';
  }.property('status'),

  getASI: function () {
    return this.get('asi');
  }.property('asi'),

  getRFI: function () {
    return this;
  }.property(),

  rfi_id: function () {
    return this.get('id');
  }.property('id'),

  asi_id: function () {
    return !this.get('asi') ? '' : this.get('asi.id');
  }.property('asi', 'asi.id'),

  status: function () {
    return !this.get('asi') ? 'Open' : this.get('asi.status');
  }.property('asi', 'asi.status'),

  plan_sheets_affected: function () {
    return !this.get('asi') ? '' : this.get('asi.plan_sheets_affected');
  }.property('asi', 'asi.plan_sheets_affected'),

  in_addendum: function () {
    return !this.get('asi') ? '' : this.get('asi.in_addendum');
  }.property('asi', 'asi.in_addendum')
});

