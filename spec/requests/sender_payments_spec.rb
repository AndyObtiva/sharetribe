require 'rails_helper'

RSpec.describe "Sender Payments", type: :request do
  describe "GET /sender_payments" do
    it "works! (now write some real specs)" do
      transaction = FactoryGirl.create(:transaction)
      get sender_person_transaction_sender_payments_path(transaction_id: transaction.id, person_id: transaction.author.id)
      expect(response).to have_http_status(200)
    end
  end
end
