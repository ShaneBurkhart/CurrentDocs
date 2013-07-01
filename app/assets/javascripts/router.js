PlanSource.Router.map(function(){

	this.resource('jobs', function(){
		this.resource('job', {path : ":job_id"});
	});

});