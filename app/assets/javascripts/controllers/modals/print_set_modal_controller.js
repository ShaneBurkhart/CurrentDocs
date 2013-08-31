PlanSource.PrintSetController = PlanSource.ModalController.extend({

  isInPrintSet : function(plan){
    var bool = 0;
    this.get("model").get("print_set").get("plans").forEach(function(inSet){
      if(plan.get("id") == inSet.get("id"))
        bool = 1;
    });
    return bool == 0 ? false : true;
  }.property(),

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