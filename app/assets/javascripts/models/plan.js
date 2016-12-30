PlanSource.Plan = Ember.Object.extend({
  statusOptions:['', 'Submitted', 'Approved', 'Approved as Corrected', 'Revise & Resubmit', 'Record Copy'],


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

  fileIsPDF:function(){
    if(this.get('filename').toLowerCase().indexOf('.pdf') > 0){
      return true;
    }
    return false;
  }.property('fileIsPDF'),

  deleteRecord : function(){
    this.destroy();
  },

  planRecords:function(){
    PlanSource.PlanRecord._getPlanRecordsFromServer(this.get('id'));
    return PlanSource.PlanRecord.planRecords;
    // return ['ello', 'mas', 'amigos']
  }.property('planRecords'),

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
              status: self.get("status")
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
