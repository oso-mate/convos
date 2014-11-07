require 'spec_helper'

describe ConvosController do

  describe "POST /convos" do
    it "has a route" do
      expect(post: "/convos").to route_to controller: "convos", action: "create"
    end
  end

  describe "PATCH /convos/:convo_id" do
    it "has a route" do
      expect(patch: "/convos/1001").to route_to controller: "convos", action: "update", convo_id: "1001"
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