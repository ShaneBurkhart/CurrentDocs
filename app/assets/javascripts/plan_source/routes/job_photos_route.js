PlanSource.JobPhotosRoute = Ember.Route.extend({
  tab: 'Photos',

  setupController: function (controller, model) {
    var jobController = this.controllerFor('job');

    controller.set('jobController', jobController);
    controller.set('model', model);
  },

  model: function () {
    var jobPromise = this.modelFor('job');

    return Em.Deferred.promise(function (p) {
      // The parent controller (job) gives a promise for it's model.
      jobPromise.then(function (job) {
        job.getPhotos(function (photos) {
          p.resolve(photos);
        });
      });
    });
  }
});
