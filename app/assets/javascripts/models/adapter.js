DS.RESTAdapter.map('PlanSource.Job',{
	plans : {embedded : 'load'},
	user : {embedded : 'load'},
	sharedUsers : {embedded : 'load'}
});