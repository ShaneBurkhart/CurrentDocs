PlanSource.JobsIndexController = Ember.ArrayController.extend({
	sortProperties: ['sorter'],
  sortAscending: true,
  content : Em.A(),

  removeJob : function(job){
  	this.get("content").removeObject(job);
  	job.deleteRecord();
		job.save();
  },

  addJob : function(new_job){
    if(this.jobExists(new_job)) return false;
    var self = this;
  	this.get("content").pushObject(new_job);
  	new_job.save().then(function(data){
      if(data == false)
        self.get("content").removeObject(new_job);
    });
    return true;
  },

  jobExists : function(new_job){
    for(var i = 0 ; i < this.get("content").length ; i++){
      var job = this.get("content")[i];
      if(job.get("name") == new_job.get("name"))
        return true;
    }
    return false;
  },

  updateJobs : function(){
    var self = this;
    PlanSource.Job.findAll().then(function(jobs){
      self.set("content", jobs);
    });
  }
});