PlanSource.SubmittalController = PlanSource.ModalController.extend({
  // 3 states: new, review, and view
  // new - no model
  // review - model exists but is in review
  // view - model exists and is not in review

	keyPress : function(e){
		if (e.keyCode == 27){
			this.send('close');
		}
	}
});
