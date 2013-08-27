PlanSource.PrintSetController = PlanSource.ModalController.extend({

	savePrintSet : function(){
    var checked_plans = [];
    $(".print_set_checkbox").each(function(index, checkbox){
      var el = $(this);
      if(el.is(":checked"))
        checked_plans.push(el.data("plan"));
    });
    this.get("parent").savePrintSet(checked_plans)
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.savePrintSet();
	}
});