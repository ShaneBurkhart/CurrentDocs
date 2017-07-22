PlanSource.SubmittalController = PlanSource.ModalController.extend({
  // 3 states: new, review, and view
  // new - no model
  // review - model exists but is in review
  // view - model exists and is not in review

  isNew: function () {
    return !this.get("model");
  }.property("model"),

  isInReview: function () {
    var submittal = this.get("model");
    return submittal && !submittal.get("is_accepted");
  }.property("model.is_accepted"),

  isAccepted: function () {
    return !this.get("isInReview");
  }.property("isInReview"),

	keyPress : function(e){
		if (e.keyCode == 27){
			this.send('close');
		}
	}
});
