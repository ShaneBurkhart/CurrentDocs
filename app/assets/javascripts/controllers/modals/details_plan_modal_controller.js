PlanSource.DetailsPlanController = PlanSource.ModalController.extend({
	job : {},

	init:function(){
		this._super();

	},

	closeModal : function(){
		jQuery('#myModal').modal('hide');
		$('body').removeClass('modal-open');
		this.send('close');
	},

	keyPress : function(e){
		console.log(e);
		if (e.keyCode == 27){
			this.send('closeModal');
		}
	}
});
