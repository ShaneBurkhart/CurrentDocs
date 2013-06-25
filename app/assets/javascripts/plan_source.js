//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require ./store
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./helpers
//= require_tree ./templates
//= require ./router
//= require_tree ./routes

PlanSource = Ember.Application.create({
	rootElement : "#ember-job-app"
});

$.fn.upload = function(remote, successFn, progressFn) {
    return this.each(function() {

        var formData = new FormData(this);

        $.ajax({
            url: remote,
            type: 'POST',
            xhr: function() {
                var myXhr = $.ajaxSettings.xhr();
                if(myXhr.upload && progressFn){
                    myXhr.upload.addEventListener('progress', progressFn, false);
                }
                return myXhr;
            },
            data: formData,
            cache: false,
            contentType: false,
            processData: false,
            complete : function(res) {
                if(successFn) successFn(res);
            }
        });
    });
}

$(document).ready(function(){
	$("#file").change(function(){
		if(!$(this).val() || $(this).val() == "")
			return;
		var plan_id = $("#plan_id").val();
		$("#plan_source_upload_form").upload("/api/upload", function(){
			PlanSource.Plan.find(plan_id).reload();
            $(".loading").slideUp(75);
		}, function(p){
            $(".loading").slideDown(75);
            $(".loading-percent").text(Math.floor(p.loaded/p.total*100));
		});
		$(this).val("");
	});	
});


PlanSource.download = function(plan_id){
    if(plan_id)
        $(".downloader").attr("src", "/api/download/" + plan_id);
}