class Api::JobsController < ApplicationController
  before_filter :user_not_there!, except: :show_sub_share_link
  before_filter :check_share_link_token!, only: :show_sub_share_link

  def index
    if user.can? :read, Job
      @jobs = get_jobs
      render json: @jobs
    else
      render_no_permission
    end
  end

  def show
    if user.can? :read, Job
      @job = get_job(params[:id])
      if user.is_my_job(@job) || user.is_shared_job(@job)
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
        @job.name = params[:job][:name]
        @job.update_attributes params[:job]
        render json: @job
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

      # TODO check the permission set in the admin panel for whether they can send links.
      # For now, it's just anyone who owns the job.
      if @job && user.is_my_job(@job)
        @share_link = ShareLink.new(
            job_id: @job.id,
            user_id: user.id,
            email_shared_with: @email_to_share_with
        )

        if @share_link.save()
          UserMailer.share_link_notification(@share_link, @job, user).deliver
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
        if !params[:share_link_token] || !ShareLink.find_by_token_and_job_id(params[:share_link_token], params[:id])
            not_found
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
