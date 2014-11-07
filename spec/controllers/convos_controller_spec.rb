require 'spec_helper'

describe ConvosController do

  describe "POST /convos" do
    it "has a route" do
      expect(post: "/convos").to route_to controller: "convos", action: "create"
    end

    context "Convo is created" do
      let!(:attributes) do
        {
          sender_user_id: 11,
          recipient_user_id: 12,
          subject_line: "I have an idea!",
          body: "Meet me downstairs, let's get some wood!"
        }
      end

      before do
        post :create, convo: attributes
      end

      specify do
        expect(response.code).to eq "201"
      end
    end

    context "Convo is not created" do
      before do
        post :create, {}
      end

      specify do
        expect(response.code).to eq "400"
      end
    end
  end

  describe "PATCH /convos/:convo_id" do
    it "has a route" do
      expect(patch: "/convos/1001").to route_to controller: "convos", action: "update", convo_id: "1001"
    end

    let!(:attributes) do
      {
        convo_id: 1001,
        sender_user_id: 11,
        recipient_user_id: 12,
        subject_line: "I have an idea!",
        body: "Meet me downstairs, let's get some wood!"
      }
    end

    let!(:convo) do
      Convo.create attributes
    end

    context "Convo is updated" do
      before do
        expect(convo.state).to eq "new"
        patch :update, convo_id: "1001", convo: { state: "read" }
      end

      specify do
        expect(response.code).to eq "200"
        expect(convo.reload.state).to eq "read"
      end
    end

    context "Convo is not updated" do
      before do
        expect(convo.state).to eq "new"
        patch :update, convo_id: "1001", convo: { state: "unread" }
      end

      specify do
        expect(response.code).to eq "400"
        expect(convo.reload.state).to eq "new"
      end
    end

    context "Convo is not found" do
      before do
        patch :update, convo_id: "9999", convo: { state: "read" }
      end

      specify do
        expect(response.code).to eq "404"
      end
    end
  end

  describe "GET /convos" do
    it "has a route" do
      expect(get: "/convos").to route_to controller: "convos", action: "index"
    end

    context "Convos are found" do
      before do
        User.create user_id: 11, user_name: "geppetto"
        get :index, user_id: "11"
      end

      specify do
        expect(response.code).to eq "200"
      end
    end

    context "User Parameter missing" do
      before do
        get :index, state: "new"
      end

      specify do
        expect(response.code).to eq "400"
      end
    end

    context "Convos are not found for User" do
      before do
        get :index, user_id: "99"
      end

      specify do
        expect(response.code).to eq "404"
      end
    end
  end

  describe "GET /convos/:convo_id" do
    it "has a route" do
      expect(get: "/convos/1001").to route_to controller: "convos", action: "show", convo_id: "1001"
    end

    context "Convo is found" do
      let!(:attributes) do
        {
          convo_id: 1001,
          sender_user_id: 11,
          recipient_user_id: 12,
          subject_line: "I have an idea!",
          body: "Meet me downstairs, let's get some wood!"
        }
      end

      before do
        Convo.create attributes
        get :show, convo_id: "1001"
      end

      specify do
        expect(response.code).to eq "200"
      end
    end

    context "Convo is not found" do
      before do
        get :show, convo_id: "9999"
      end

      specify do
        expect(response.code).to eq "404"
      end
    end
  end

  describe "DELETE /convos/:convo_id" do
    it "has a route" do
      expect(delete: "/convos/999").to route_to controller: "convos", action: "destroy", convo_id: "999"
    end
  end

end