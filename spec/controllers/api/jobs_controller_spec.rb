require 'rails_helper'

RSpec.describe Api::JobsController, :type => :controller do
  context "when a user is logged in" do
    let(:user) { create(:user) }
    let(:job) { user.jobs.first }
    before(:each) { login user }

    context "and is authorized" do
      before(:each) { allow_any_instance_of(User).to receive(:can?).and_return(true) }

      describe "GET #index" do
        before(:each) { get :index }
        it { expect(response).to be_authorized }

        it "should return the user's jobs with includes" do
          responseJSON = JSON.parse(response.body)
          jobs = responseJSON["jobs"]

          expect(jobs).to be_an_instance_of(Array)
          jobs.each do |j|
            # Verify has includes
            expect(j["user"]).to be_an_instance_of(Hash)
            expect(j["plans"]).to be_an_instance_of(Array)

            expect(j["user"]["id"]).to eq(subject.user.id)
          end
        end
      end

      describe "GET #show" do
        context "when job belongs to user" do
          let(:job) { create(:job, user: subject.user) }
          before(:each) { get :show, id: job.id }

          it { expect(response).to be_authorized }

          it "should return the user's job with includes" do
            responseJSON = JSON.parse(response.body)
            j = responseJSON["job"]

            expect(j).to be_an_instance_of(Hash)
            expect(j["id"]).to eq(job.id)

            expect(j["user"]).to be_an_instance_of(Hash)
            expect(j["plans"]).to be_an_instance_of(Array)
          end
        end

        context "when job doesn't exist" do
          before(:each) { get :show, id: 0 }
          it { expect(response).not_to be_authorized }
        end
      end

      describe "POST #create" do
        context "when new job is valid" do
          before(:each) { post :create, job: { name: "Job name" } }
          it { expect(response).to be_authorized }

          it "should return a new job with includes" do
            responseJSON = JSON.parse(response.body)
            j = responseJSON["job"]

            expect(j).to be_an_instance_of(Hash)
            expect(j["name"]).to eq("Job name")

            expect(j["user"]).to be_an_instance_of(Hash)
            expect(j["plans"]).to be_an_instance_of(Array)
          end
        end

        context "when new job is not valid" do
          before(:each) do
            allow_any_instance_of(Job).to receive(:save).and_return(false)
            post :create, job: { name: "Job name" }
          end

          it { expect(response).to be_authorized }

          it "should return an error" do
            responseJSON = JSON.parse(response.body)
            expect(responseJSON["error"]).not_to be_nil
          end
        end
      end

      describe "PUT #update" do
        context "when updated job is valid" do
          before(:each) { put :update, id: job.id, job: { name: "Some job name" } }
          it { expect(response).to be_authorized }

          it "should return the updated job with includes" do
            responseJSON = JSON.parse(response.body)
            j = responseJSON["job"]

            expect(j).to be_an_instance_of(Hash)
            expect(j["name"]).to eq("Some job name")

            expect(j["user"]).to be_an_instance_of(Hash)
            expect(j["plans"]).to be_an_instance_of(Array)
          end
        end

        context "when updated job is not valid" do
          before(:each) do
            allow_any_instance_of(Job).to(
              receive(:update_attributes).and_return(false)
            )
            put :update, id: job.id, job: { name: "Job name" }
          end

          it { expect(response).to be_authorized }

          it "should return an error" do
            responseJSON = JSON.parse(response.body)
            expect(responseJSON["error"]).not_to be_nil
          end
        end

        context "when job doesn't exist" do
          before(:each) { put :update, id: 0, job: { name: "Job name" } }
          it { expect(response).not_to be_authorized }
        end
      end

      describe "DELETE #destroy" do
        context "when job exists" do
          before(:each) do
            expect_any_instance_of(Job).to receive(:destroy)
            delete :destroy, id: job.id
          end

          it { expect(response).to be_authorized }

          it "should return nothing" do
            responseJSON = JSON.parse(response.body)
            expect(responseJSON).to be_empty
          end
        end

        context "when job doesn't exist" do
          before(:each) { delete :destroy, id: 0 }
          it { expect(response).not_to be_authorized }
        end
      end
    end

    context "but is not authorized" do
      before(:each) {
        allow_any_instance_of(User).to receive(:can?).and_return(false)
      }

      describe "GET #index" do
        before(:each) do
          expect_any_instance_of(User).to receive(:can?).with(:read_multiple, all(be_a(Job)))
          get :index
        end

        it { expect(response).not_to be_authorized }
      end

      describe "GET #show" do
        before(:each) do
          expect_any_instance_of(User).to receive(:can?).with(:read, be_a(Job))
          get :show, id: 1
        end

        it { expect(response).not_to be_authorized }
      end

      describe "POST #create" do
        before(:each) do
          expect_any_instance_of(User).to receive(:can?).with(:create, eq(Job))
          post :create, job: { name: "Job name" }
        end

        it { expect(response).not_to be_authorized }
      end

      describe "PUT #update" do
        before(:each) do
          expect_any_instance_of(User).to receive(:can?).with(:update, be_a(Job))
          put :update, id: 1, job: { name: "New job name" }
        end

        it { expect(response).not_to be_authorized }
      end

      describe "DELETE #destroy" do
        before(:each) do
          expect_any_instance_of(User).to receive(:can?).with(:destroy, be_a(Job))
          delete :destroy, id: 1
        end

        it { expect(response).not_to be_authorized }
      end
    end
  end

  describe "when a user is not logged in" do
    before(:each) { logout }

    describe "GET #index" do
      before(:each) { get :index }
      it { expect(response).not_to be_authenticated }
    end

    describe "GET #show" do
      before(:each) { get :show, id: 1 }
      it { expect(response).not_to be_authenticated }
    end

    describe "POST #create" do
      before(:each) { post :create, job: { name: "Job name" } }
      it { expect(response).not_to be_authenticated }
    end

    describe "PUT #update" do
      before(:each) { put :update, id: 1 }
      it { expect(response).not_to be_authenticated }
    end

    describe "DELETE #destroy" do
      before(:each) { delete :destroy, id: 1 }
      it { expect(response).not_to be_authenticated }
    end
  end
end
