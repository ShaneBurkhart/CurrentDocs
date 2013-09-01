PlanSource.PrintController = Ember.ObjectController.extend({

  isInPrintSet : function(){
    var bool = 0;
    var self = this;
    this.get("parentController").get("model").get("print_set").get("plans").forEach(function(inSet){
      if(self.get("model").get("id") == inSet.get("id"))
        bool = 1;
    });
    return bool == 0 ? "" : "checked";
  }.property().volatile()

});
