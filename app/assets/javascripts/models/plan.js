PlanSource.Plan = Ember.Object.extend({
  statusOptions:['', 'Submitted', 'Approved', 'Approved as Corrected', 'Revise & Resubmit', 'Record Copy'],
  planRecords: [],

  init:function(){
    this.getPlanRecords();
  },

  isSelected : function(option, status){
    if (status == option){
      return "selected";
    }
    return "";
  }.property('isSelected'),

  hasPlan: function() {
    return this.get("plan_file_name") != null && this.get("plan_file_name") != "";
  }.property("plan_file_name"),

  belongsToShops: function() {
    if (this.get("tab") === 'Shops'){
      return true;
    }else{
      return false;
    }
  }.property('belongsToShops'),

  belongsToASI: function() {
    if (this.get("tab") === 'ASI'){
      return true;
    }else{
      return false;
    }
  }.property('belongsToASI'),

  isNotShopOrASI:function(){
    return !(this.get("belongsToShops") || this.get("belongsToASI"))
  }.property('isNotShopOrASI'),

  fileIsPDF:function(){
    if(this.get('filename').toLowerCase().indexOf('.pdf') > 0){
      return true;
    }
    return false;
  }.property('fileIsPDF'),

  deleteRecord : function(){
    this.destroy();
  },

  getDescriptionString:function(){
    var tempCont = document.createElement("div");
    var quil = new Quill(tempCont);
    if(this.get('description') != null){
      quil.setContents(JSON.parse(this.get("description")));
      return quil.getText();
    }
    return ""
  }.property("getDescriptionString"),

  getDescriptionHTML:function(){
    var tempCont = document.createElement("div");
    var quil = new Quill(tempCont);
    quil.setContents(JSON.parse(this.get("description")));
    return quil.root.innerHTML;
  }.property('getDescriptionHTML'),

  filenameOrDefault:function(){
    if(this.get('filename') == null)
    return "No file attached";
    return this.get('filename');
  }.property('filenameOrDefault'),

  tagsOrDefault:function(){
    if(this.get('tags') == null)
    return 'None';
    return this.get('tags');
  }.property('tagsOrDefault'),

  planRecordsProp:function(){
    return this.planRecords;
  }.property(),

  getPlanURI: function(){
    var planURL = this.get('plan');
    console.log("Here's the plan: " + planURL);
    return planURL;

  }.property("getPlanURI"),

  save : function(){
    if(this.get("isDestroyed") || this.get("isDestroying")){
      return this._deleteRequest();
    }else{
      if(this.get("id")) ///Not news
      return this._updateRequest();
      else
      return this._createRequest();
    }
  },

  getPlanRecords:function(){
    var self = this;
    Em.Deferred.promise(function(p){
      p.resolve($.get(PlanSource.PlanRecord.url(self.get('id'))).then(function(data){
        self.clearPlanRecords();
        data.plans.forEach(function(planRecord){
          self.planRecords.push(PlanSource.PlanRecord.create(planRecord.plans));
        });
        return self.planRecords;
      }));
    });
  },

  clearPlanRecords: function() {
    this.planRecords = [];
  },

  upatePlanRecords : function(updateData){
    var updateDataString = JSON.stringify(updateData);
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
        url: PlanSource.PlanRecord.baseUrl,
        type: 'POST',
        data : { update : updateDataString },
        success:function(data){
          console.log("Successful plan record update", data);
        },
        error:function(err){
          console.log("UNsuccessful plan record update", err);
          // toastr["error"]("Could not save " + self.get('plan_name'));
        }
      }).then(function(data){
        // self.setProperties(data.plan);
      })
    );
  });
},

_createRequest : function(){
  var self = this;
  return Em.Deferred.promise(function(p){
    p.resolve($.ajax({
      url: PlanSource.Plan.url(),
      type: 'POST',
      data : { plan : {
        plan_name : self.get("plan_name"),
        csi : self.get("csi"),
        job_id : self.get("job").get("id"),
        tab: self.get('tab')
      }}
    }).then(function(data, t, xhr){
      if(!$.isEmptyObject(data)){
        self.setProperties(data.plan);
        return true;
      }else
      return false;
    })
  );
});
},

_updateRequest : function(){
  var self = this;
  return Em.Deferred.promise(function(p){
    p.resolve($.ajax({
      url: PlanSource.Plan.url(self.get("id")),
      type: 'PUT',
      data : { plan : {
        plan_num : self.get("plan_num"),
        csi : self.get("csi"),
        plan_name : self.get("plan_name"),
        status: self.get("status"),
        description: self.get('description'),
        code: self.get('code'),
        tags: self.get('tags')
      }},
      success:function(data){
        toastr["success"]("Successfully saved " + self.get('plan_name'));
      },
      error:function(){
        toastr["error"]("Could not save " + self.get('plan_name'));
      }
    }).then(function(data){
      self.setProperties(data.plan);
    })
  );
});
},

_deleteRequest : function(){
  var self = this;
  var preDeleteName = self.get('plan_name');
  return Em.Deferred.promise(function(p){
    p.resolve($.ajax({
      url: PlanSource.Plan.url(self.get("id")),
      type: 'DELETE',
      success:function(data){
        toastr["success"]("Successfully deleted " + preDeleteName);
      },
      error:function(){
        toastr["error"]("Could not delete " + preDeleteName);
      }
    }).then(function(data){

    })
  );
});
}

});

PlanSource.Plan.reopenClass({
  baseUrl : "/api/plans",

  url : function(id){
    var pathArray = window.location.href.split( '/' ),
    host = pathArray[2],
    u = PlanSource.getProtocol() + host + PlanSource.Plan.baseUrl;
    if(id) return u + "/" + id;
    return u;
  }

});
