PlanSource.Router.map(function (){
	this.resource('jobs', function (){
		this.resource('job', { path : ":job_id" }, function () {
      this.route('plans');
      this.route('addendums');
      this.route('rfi-asi');
      this.route('shops');
      this.route('support');
      this.route('calcs');
      this.route('photos');
    });
	});
});
