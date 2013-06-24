PlanSource.Router.map(function(){

	this.resource('jobs', function(){
		this.resource('plans', {path : ":job_id/plans"});
	});

});