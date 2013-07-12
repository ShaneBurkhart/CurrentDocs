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
	rootElement : "#ember-job-app",
    LOG_TRANSITIONS: true
});

Ember.Handlebars.registerBoundHelper("date", function(date){
    if(date)
        return moment(date).fromNow();
    else
        return "";
});
Handlebars.registerHelper('manager', function(options) {
    if(PlanSource._user_type == "Manager")
        return options.fn(this);
    else
        return options.inverse(this);
});

$.fn.upload = function(plan_id, remote, successFn, progressFn) {
    return this.each(function() {

        var formData = new FormData(this);
        formData.append("plan_id", plan_id);

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

/*$(document).ready(function(){
	$("#file").change(function(){
		if(!$(this).val() || $(this).val() == "")
			return;
		var plan_id = $("#plan_id").val();
		$("#plan_source_upload_form").upload("/api/upload", function(){
            $(".loading").slideUp(75);
		}, function(p){
            $(".loading").slideDown(75);
            $(".loading-percent").text(Math.floor(p.loaded/p.total*100));
		});
		$(this).val("");
	});
});
*/

PlanSource.download = function(plan_id){
    if(plan_id)
        $(".downloader").attr("src", "/api/download/" + plan_id);
}