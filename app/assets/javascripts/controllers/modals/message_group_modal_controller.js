PlanSource.MessageGroupController = PlanSource.ModalController.extend({

  sendMessage : function() {
    var message = $('#message-to-group').val().trim();
    var confirmSend = confirm(
      [
        "Your message:\n\n",
        message,
        "\n\n",
        "Do you want to send this message to the group?"
      ].join("")
    );

    if(confirmSend) {
      $.post("/api/message", {
          "job_id": this.get("job.id"),
          "message": message
        },
        function(data){},
        "json"
      );
      this.send("close");
    }
  }

});
