require 'spec_helper'

describe ConvosController do

  describe "POST /convos" do
    it "has a route" do
      expect(post: "/convos").to route_to controller: "convos", action: "create"
    end

    context "201" do
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

    context "400" do
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

    context "200" do
      before do
        expect(convo.state).to eq "new"
        patch :update, convo_id: "1001", convo: { state: "read" }
      end

      specify do
        expect(response.code).to eq "200"
        expect(convo.reload.state).to eq "read"
      end
    end

    context "400" do
      before do
        expect(convo.state).to eq "new"
        patch :update, convo_id: "1001", convo: { state: "unread" }
      end

      specify do
        expect(response.code).to eq "400"
        expect(convo.reload.state).to eq "new"
      end
    end

    context "404" do
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
  end

  describe "GET /convos/:convo_id" do
    it "has a route" do
      expect(get: "/convos/1001").to route_to controller: "convos", action: "show", convo_id: "1001"
    end
  end

  describe "DELETE /convos/:convo_id" do
    it "has a route" do
      expect(delete: "/convos/999").to route_to controller: "convos", action: "destroy", convo_id: "999"
    end
  end

end