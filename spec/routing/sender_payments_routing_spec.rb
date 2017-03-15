require "rails_helper"

RSpec.describe SenderPaymentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/sender_payments").to route_to("payments#index")
    end

    it "routes to #new" do
      expect(:get => "/sender_payments/new").to route_to("payments#new")
    end

    it "routes to #show" do
      expect(:get => "/sender_payments/1").to route_to("payments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/sender_payments/1/edit").to route_to("payments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/sender_payments").to route_to("payments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/sender_payments/1").to route_to("payments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/sender_payments/1").to route_to("payments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/sender_payments/1").to route_to("payments#destroy", :id => "1")
    end

  end
end
