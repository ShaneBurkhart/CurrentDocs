class PlansController < ApplicationController
  def new
    @plan = Plan.new(job_id: params[:job_id], tab: params[:tab])

    respond_to do |format|
      format.html
      format.modal{ render :new, formats: [:html], layout: false }
    end
  end

  def create
    @plan = Plan.new(params[:plan])
    @plan.job_id = params[:job_id]
    @plan.tab = params[:tab]

    if !@plan.save
      return render :new
    end

    redirect_to job_tab_path(@plan.job_id, @plan.tab)
  end

  def edit
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html
      format.modal{ render :new, formats: [:html], layout: false }
    end
  end

  def update
    @plan = Plan.find(params[:id])

    if !@plan.update_attributes(params[:plan])
      return render :new
    end

    redirect_to job_tab_path(@plan.job_id, @plan.tab)
  end

  def should_delete
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html
      format.modal{ render :should_delete, formats: [:html], layout: false }
    end
  end

  def destroy
    @plan = Plan.find(params[:id])

    @plan.destroy

    redirect_to job_tab_path(@plan.job_id, @plan.tab)
  end
end
