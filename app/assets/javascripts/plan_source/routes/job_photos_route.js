PlanSource.JobPhotosRoute = Ember.Route.extend({
  tab: 'Photos',

  setupController: function (controller, model) {
    var jobController = this.controllerFor('job');

    controller.set('jobController', jobController);
    controller.set('content', model);
  },

  model: function () {
    var jobPromise = this.modelFor('job');
    var resolvedPhotos = Em.A();

    // Check if the model is a promise
    if (jobPromise.then) {
      // jobPromise is a promise
      return Em.Deferred.promise(function (p) {
        jobPromise.then(function (job) {
          job.getPhotos(function (photos) {
            for (var i = 0; i < photos.length; i++) {
              resolvedPhotos.push(photos[i]);
            }

            p.resolve(photos);
          });
        });
      });
    } else {
      // jobPromise is a Job object
      jobPromise.getPhotos(function (photos) {
        for (var i = 0; i < photos.length; i++) {
          resolvedPhotos.push(photos[i]);
        }
      });
    }

    return resolvedPhotos;
  }
});
