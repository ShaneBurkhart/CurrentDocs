PlanSource.JobsIndexController = Ember.ArrayController.extend({
	sortProperties: ['sorter'],
  sortAscending: true,

  removeJob : function(job){
  	this.get("content").removeObject(job);
  	job.deleteRecord();
		job.save();
  },

  addJob : function(job){
  	this.get("content").pushObject(job);
  	job.save();
  }
});