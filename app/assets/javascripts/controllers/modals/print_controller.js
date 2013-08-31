PlanSource.PrintController = Ember.ObjectController.extend({

  isInPrintSet : function(){
    var bool = 0;
    console.log(this.get("parentController"));
    this.get("parentController").get("model").get("print_set").get("plans").forEach(function(inSet){
      if(this.get("model").get("id") == inSet.get("id"))
        bool = 1;
    });
    return bool == 0 ? "" : "checked";
  }.property()

});
