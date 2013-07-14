PlanSource.JobsIndexController = Ember.ArrayController.extend({
	//sortProperties: ['sorter'],
  //sortAscending: true,

  removeJob : function(job){
  	this.get("content").removeObject(job);
  	job.deleteRecord();
		job.save();
  },

  addJob : function(job){
    var self = this;
  	this.get("content").pushObject(job);
  	job.save().then(function(data){
      if(data == false)
        self.get("content").removeObject(job);
    });
  },

  updateJobs : function(){
    var self = this;
    PlanSource.Job.findAll().then(function(jobs){
      self.set("content", jobs);
    });
  }
});