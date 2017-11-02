PlanSource.RfiAsiController = PlanSource.ModalController.extend({
	keyPress : function(e){
		if (e.keyCode == 13)
			this.send('close');
	}
});

