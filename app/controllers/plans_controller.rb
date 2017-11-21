class PlansController < ApplicationController
  before_filter :authenticate_user!

  def new
    @plan = Plan.new(job_id: params[:job_id], tab: params[:tab])

    authorize! :create, Plan

    respond_to do |format|
      format.html
      format.modal{ render :new, formats: [:html], layout: false }
    end
  end

  def create
    @plan = Plan.new(params[:plan])
    @plan.job_id = params[:job_id]
    @plan.tab = params[:tab]

    authorize! :create, Plan

    if !@plan.save
      return render :new
    end

    redirect_to job_tab_path(@plan.job_id, @plan.tab)
  end

  def edit
    @plan = Plan.find(params[:id])

    authorize! :update, @plan

    respond_to do |format|
      format.html{ render :new }
      format.modal{ render :new, formats: [:html], layout: false }
    end
  end

  def update
    @plan = Plan.find(params[:id])

    authorize! :update, @plan

    if !@plan.update_attributes(params[:plan])
      return render :new
    end

    redirect_to job_tab_path(@plan.job_id, @plan.tab)
  end

  def should_delete
    @plan = Plan.find(params[:id])

    authorize! :destroy, @plan

    respond_to do |format|
      format.html
      format.modal{ render :should_delete, formats: [:html], layout: false }
    end
  end

  def destroy
    @plan = Plan.find(params[:id])

    authorize! :destroy, @plan

    @plan.destroy

    redirect_to job_tab_path(@plan.job_id, @plan.tab)
  end
end
