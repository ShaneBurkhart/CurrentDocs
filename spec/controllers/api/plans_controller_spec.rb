require 'spec_helper'

describe Api::PlansController do

	before(:each) do
		Plan.delete_all
		Job.delete_all
    @manager = FactoryGirl.create :manager
    @job = FactoryGirl.create :job
    sign_in @manager
  end
  # This should return the minimal set of attributes required to create a valid
  # Api::Job. As you add validations to Api::Job, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {
    plan_name: "Plan Name",
    filename: "file.pdf",
    job_id: 1,
    plan_num: 1
  } }

  describe "GET index" do
    it "should output plans as json" do
      plan = Plan.create! valid_attributes
      get :index, {}
      response.body.should == {plans: [plan]}.to_json
    end
  end

  describe "GET show" do
    it "should output json for plsn" do
      plan = Plan.create! valid_attributes
      get :show, {:id => plan.to_param}
      response.body.should == {plan: plan}.to_json
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new plan and outputs JSON" do
        expect {
          post :create, {:plan => valid_attributes}
        }.to change(Plan, :count).by(1)
        response.body.should == {plan: Plan.find_by_plan_name(valid_attributes[:plan_name])}.to_json
      end

      it "can not be created by viewer" do
        sign_out :user
        sign_in FactoryGirl.create :viewer
        expect {
          post :create, {:plan => valid_attributes}
        }.to change(Plan, :count).by(0)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested plan" do
        update_attr = {plan_name: "Updated Plan"}
        plan = Plan.create! valid_attributes
        put :update, {:id => plan.to_param, :plan => update_attr}
        response.body.should have_content update_attr[:plan_name]
      end

      it "should output updated plan as JSON" do
        plan = Plan.create! valid_attributes
        put :update, {:id => plan.to_param, :plan => valid_attributes}
        response.body.should == {plan: plan}.to_json
      end

      it "can not be updated by viewer" do
        plan = Plan.create! valid_attributes
        sign_out :user
        sign_in FactoryGirl.create :viewer
        put :update, {:id => plan.to_param, :plan => valid_attributes}
        response.body.should == "You don't have permission to do that"
      end
    end

    describe "with invalid params" do
      it "assigns the plan as @plan" do
        plan = Plan.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        put :update, {:id => plan.to_param, :plan => {  }}
        assigns(:plan).should eq(plan)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested plan" do
      plan = Plan.create! valid_attributes
      expect {
        delete :destroy, {:id => plan.to_param}
      }.to change(Plan, :count).by(-1)
    end
  end
end
