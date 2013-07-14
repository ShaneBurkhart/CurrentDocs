PlanSource.ModalController = Ember.ObjectController.extend({

	error : function(input_id, msg){
		var text = $(input_id).siblings(".help-inline"),
			cont = text.parent().parent();
		cont.addClass("error");
		text.text(msg);
	},

	clearError : function(input_id, msg){
		var text = $(input_id).siblings(".help-inline"),
			cont = text.parent().parent();
			cont.removeClass("error");
			text.text("");
	},

	clearAllErrors : function(){
		var errors = $(".control-group");
		errors.find(".help-inline").text("");
		errors.removeClass("error");
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
		var infos = $(".control-group");
		infos.find(".help-inline").text("");
		infos.removeClass("info");
	}

});