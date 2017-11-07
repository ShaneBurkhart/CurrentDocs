PlanSource.RFI = Ember.Object.extend({
  init : function() {
    this.setProperties(this.getProperties('asi'));
  },

  setProperties : function(hash) {
    if(hash.asi){
      var asi = PlanSource.ASI.create(hash.asi);
      // Pass a reference of this RFI to ASI
      asi.set('rfi', this);
      this.set('asi', asi);
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

  asi_num: function () {
    return !this.get('asi') ? null : this.get('asi.asi_num');
  }.property('asi', 'asi.id'),

  status: function () {
    return !this.get('asi') ? 'Open' : this.get('asi.status');
  }.property('asi', 'asi.status'),

  plan_sheets_affected: function () {
    return !this.get('asi') ? '' : this.get('asi.plan_sheets_affected');
  }.property('asi', 'asi.plan_sheets_affected'),

  in_addendum: function () {
    return !this.get('asi') ? '' : this.get('asi.in_addendum');
  }.property('asi', 'asi.in_addendum'),

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

  validate: function () {
    var errors = {};

    if (!this.get("subject")) {
      errors.subject = "Can't be blank.";
    }

    return $.isEmptyObject(errors) ? undefined : errors;
  },

  submit: function (callback) {
    var self = this;

    $.ajax({
        url: PlanSource.RFI.url(),
        type: 'POST',
        data : { rfi: this.getProperties([
          "job_id",
          "subject",
          "notes",
          "attachment_ids"
        ]) },
    }).then(function(data, t, xhr){
      if (!$.isEmptyObject(data)) {
        self.setProperties(data.rfi);
        return callback(self);
      } else {
        return callback(undefined);
      }
    })
  }
});

PlanSource.RFI.reopenClass({
  baseUrl : "/api/rfis",

  deleteUrl: function (id) {
    return PlanSource.RFI.url() + "/" + id + "/destroy";
  },

  saveUrl: function (id) {
    return PlanSource.RFI.url() + "/" + id;
  },

  url : function(){
    var pathArray = window.location.href.split( '/' ),
      host = pathArray[2],
      u = PlanSource.getProtocol() + host + PlanSource.RFI.baseUrl;
    return u;
  }

});
