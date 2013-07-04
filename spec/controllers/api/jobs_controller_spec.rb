require 'spec_helper'

describe Api::JobsController do

  let(:valid_attributes) { {
    name: "Test Job",
    user_id: "1"
  } }

  before(:each) do
    sign_in FactoryGirl.create :user
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Job" do
        expect {
          post :create, {:job => valid_attributes}
        }.to change(Job, :count).by(1)
      end

      it "assigns a newly created job as @job" do
        post :create, {:job => valid_attributes}
        assigns(:job).should be_a(Job)
        assigns(:job).should be_persisted
      end

      it "redirects to the created job" do
        post :create, {:job => valid_attributes}
        response.should redirect_to(employers_dashboard_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job as @job" do
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        post :create, {:job => {  }}
        assigns(:job).should be_a_new(Job)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        post :create, {:job => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested job" do
        job = Job.create! valid_attributes
        # Assuming there are no other jobs in the database, this
        # specifies that the Job created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Job.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => job.to_param, :job => { "these" => "params" }}
      end

      it "assigns the requested job as @job" do
        job = Job.create! valid_attributes
        put :update, {:id => job.to_param, :job => valid_attributes}
        assigns(:job).should eq(job)
      end

      it "redirects to the job" do
        job = Job.create! valid_attributes
        put :update, {:id => job.to_param, :job => valid_attributes}
        response.should redirect_to(employers_job_path(job))
      end
    end

    describe "with invalid params" do
      it "assigns the job as @job" do
        job = Job.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        put :update, {:id => job.to_param, :job => {  }}
        assigns(:job).should eq(job)
      end

      it "re-renders the 'edit' template" do
        job = Job.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        put :update, {:id => job.to_param, :job => {  }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested job" do
      job = Job.create! valid_attributes
      expect {
        delete :destroy, {:id => job.to_param}
      }.to change(Job, :count).by(-1)
    end

    it "redirects to the jobs list" do
      job = Job.create! valid_attributes
      delete :destroy, {:id => job.to_param}
      response.should redirect_to(employers_dashboard_path)
    end
  end

end
