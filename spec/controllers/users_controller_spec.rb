require 'spec_helper'

describe UsersController do

  describe "POST /users" do
    it "has a route" do
      expect(post: "/users").to route_to controller: "users", action: "create"
    end
  end

  describe "GET /users/:user_name" do
    it "has a route" do
      expect(get: "/users/geppetto").to route_to controller: "users", action: "show", user_name: "geppetto"
    end
  end

end