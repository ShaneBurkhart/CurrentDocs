PlanSource.JobPhotosRoute = Ember.Route.extend({
  tab: 'Photos',

  setupController: function (controller) {
    var jobController = this.controllerFor('job');
    var job = jobController.get('model');
    var resolvedPhotos = Em.A();

    job.getPhotos(function (photos) {
      for (var i = 0; i < photos.length; i++) {
        resolvedPhotos.push(photos[i]);
      }
    });

    controller.set('jobController', jobController);
    controller.set('content', resolvedPhotos);
  }
});
