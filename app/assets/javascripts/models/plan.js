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

  deleteRecord : function(){
    this.destroy();
  },

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
            	plan_name : self.get("plan_name"),
              status: self.get("status")
            }}
        }).then(function(data){
          self.setProperties(data.plan);

        })
      );
    });
  },

  _deleteRequest : function(){
    var self = this;
    return Em.Deferred.promise(function(p){
      p.resolve($.ajax({
            url: PlanSource.Plan.url(self.get("id")),
            type: 'DELETE'
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
      u = "http://" + host + PlanSource.Plan.baseUrl;
    if(id) return u + "/" + id;
    return u;
  }

});
