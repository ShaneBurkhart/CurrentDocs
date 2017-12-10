class RegistrationController < ApplicationController
  # To pass options to authenticate_user! we need to call it in a block.
  before_filter { |c| c.authenticate_user!(allow: [:user]) }

  def edit
    authorize! :update, current_user

    render :edit
  end

  def update
    user_params = params[:user]

    authorize! :update, current_user

    if !current_user.update_with_password(user_params)
      return render :edit
    end

    sign_in current_user, :bypass => true

    redirect_to jobs_path
  end
end
