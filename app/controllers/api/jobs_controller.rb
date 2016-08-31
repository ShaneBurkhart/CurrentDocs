include Common

class Api::JobsController < ApplicationController
  before_filter :user_not_there!, except: [
    :show_sub_share_link,
    :share_link_company_name,
    :set_share_link_company_name
  ]
  before_filter :check_share_link_token!, only: :show_sub_share_link
  before_filter :check_company_name_cookie!, only: :show_sub_share_link

  def index
    if user.can? :read, Job
      @jobs = get_jobs
      @jobs.each do |job|
        job.subscribed = NotificationSubscription.user_is_subscribed({target_type:'job', target_id:job.id, user_id:user.id})
      end

      render json: @jobs
    else
      render_no_permission
    end
  end

  def show
    if user.can? :read, Job
      @job = get_job(params[:id])
      if user.is_my_job(@job) || user.is_shared_job(@job)
        @job.subscribed = NotificationSubscription.user_is_subscribed({target_type:'job', target_id:@job.id, user_id:user.id})
        render json: @job
      else
        render json: {job: {}}
      end
    else
      render_no_permission
    end
  end

  def create
    if user.can? :create, Job
      @job = Job.new(name: params["job"]["name"], user_id: user.id)
      if !@job.save
        render json: {}
        return
      end
      render json: @job
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Job
      @job = get_job(params[:id])
      if @job && user.is_my_job(@job)

        # TODO Should be refactored into Job model
        params[:job][:subscribed] = is_bool params[:job][:subscribed]
        subscribed = params[:job][:subscribed]
        # Update notifications
        notifs = NotificationSubscription.get_notifs_for_target(type:'job', id:@job.id, user_id:user.id)
        if notifs.present?
          notifs.each do |notif|
            if notif.is_active != subscribed
              notif.is_active = subscribed
              notif.save
            end
          end
        elsif subscribed == true
          # Create new subscription for job
          NotificationSubscription.create(target_type:'job', target_id:@job.id, user_id:user.id)
        end
        @job.update_attributes params[:job]
        puts render json: @job
      else
        render json: @job
      end
    else
      render_no_permission
    end
  end

  def destroy
    if user.can? user, :destroy, Job
      @job = Job.find(params[:id])
      if user.is_my_job @job
        if @job
          @job.destroy
          render json: {}
        else
          render :text => "No job"
        end
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  # Show the form to get company name.
  def share_link_company_name
    if cookies[:share_link_company_name].blank?
      render :share_link_company_name
    else
      redirect_to root_path
    end
  end

  # Set a cookie for the company name then redirect to the share link.
  def set_share_link_company_name
    if params[:company_name].blank?
      @error = "Company name cannot be blank."
      render :share_link_company_name
      return
    end

    cookies[:share_link_company_name] = params[:company_name]
    @url = session[:share_link_to_go_back] || root_path
    redirect_to @url
  end

  # TODO Check for cookie that contains the company name
  # If not, redirect to page to get the name and update our table.
  # If the cookie is set, we just want to update it right now.
  def show_sub_share_link
    @job = Job.find params[:id]

    if @job
      # Record that someone opened the page
      render :sub_share_link
    else
      not_found
    end
  end

  def sub_share_link
    if user.can? :update, Job
      @job = get_job(params[:job_id])
      @email_to_share_with = params[:email_to_share_with]
      @share = Share.find_by_job_id_and_user_id(params[:job_id], user.id)

      # TODO check the permission set in the admin panel for whether they can send links.
      # For now, it's just anyone who owns the job.
      if @job && (user.is_my_job(@job) || (@share && user.can_share_link))
        # No need to create a duplicate link if we already have a link from a previous share.
        @share_link = ShareLink.find_or_create_by_job_id_and_user_id_and_email_shared_with(
        job_id: @job.id,
        user_id: user.id,
        email_shared_with: @email_to_share_with
        )

        if @share_link
          UserMailer.share_link_notification(@share_link, @job, user).deliver
          flash[:notice] = "Successfully sent share link."

          # 204 since we don't need to return any content.
          render json: {}, status: 204
        else
          # Close enough to the right status.  Essentially, if it doesn't work, it was a bad
          # request.
          render json: {}, status: 400
        end
      else
        render json: {}, status: 404
      end
    else
      render_no_permission
    end
  end

  private
  def check_share_link_token!
    @share_link = ShareLink.find_by_token_and_job_id(params[:share_link_token], params[:id])
    if @share_link.nil?
      not_found
    end
  end

  def check_company_name_cookie!
    if cookies[:share_link_company_name].blank?
      session[:share_link_to_go_back] = request.original_url
      redirect_to share_link_company_name_path
    else
      @share_link.company_name = cookies[:share_link_company_name]
      @share_link.save
    end
  end

  def get_jobs
    # Kinda gross in the sense that it is essentiall duplicate include calls.  You can't merge them and
    # then run includes on the combination becuase ActiveRecord will try to tell you it's a array.
    # Alternatively, we could create a "meta" function that takes the object and calls the includes method on
    # the object passed in.  Not nearly as intuitive as this, so I'm keeping it this way.
    user.jobs.includes(:user, :plans, shares: [:user, :sharer]) + user.shared_jobs.includes(:user, :plans, shares: [:user, :sharer])
  end

  def get_job(id)
    Job.includes(:user, :plans, shares: [:user, :sharer]).find(id)
  end

  def render_no_permission
    render :text => "You don't have permission to do that"
  end
end
