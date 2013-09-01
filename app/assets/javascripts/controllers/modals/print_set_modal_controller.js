PlanSource.PrintSetController = PlanSource.ModalController.extend({

	savePrintSet : function(){
    var checked_plans = [];
    $(".print_set_checkbox").each(function(index, checkbox){
      var el = $(this);
      if(el.is(":checked"))
        checked_plans.push(el.data("plan"));
    });
    var self = this;
    $.ajax("api/print_sets/" + this.get("model").get("print_set").get("id"), {
      type : "PUT",
      data : {
        "print_set" : {
          "plan_ids" : checked_plans
        }
      },
      dataType : "json"
    }).then(function(data){
      if(data.print_set)
        self.get("model").setProperties(data);
    });
		this.send("close");
	},

	keyPress : function(e){
		if (e.keyCode == 13)
			this.savePrintSet();
	}
});