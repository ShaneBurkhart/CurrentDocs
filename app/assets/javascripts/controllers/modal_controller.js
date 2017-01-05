PlanSource.ModalController = Ember.ObjectController.extend({
  error : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
    cont = text.parent().parent();
    text.addClass("error margin-top-20");
    text.text(msg);
  },

  clearError : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
      cont = text.parent().parent();
      cont.removeClass("error");
      text.text("");
  },

  clearAllErrors : function(){
    var errors = $(".control-group").find(".controls").find(".help-inline");
    errors.each(function(e){
      e.text("");
    });
    $(".control-group").removeClass("error");
  },

  info : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
      cont = text.parent().parent();
    cont.addClass("info");
    text.text(msg);
  },

  clearInfo : function(input_id, msg){
    var text = $(input_id).siblings(".help-inline"),
      cont = text.parent().parent();
      cont.removeClass("info");
      text.text("");
  },

  clearAllInfo : function(){
    var infos = $(".control-group").find("controls").find(".help-inline");
    infos.each(function(info){
      info.text("");
    });
    $(".control-group").removeClass("info");
  }

});
