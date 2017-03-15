require 'rails_helper'

RSpec.describe "payments/new", type: :view do
  let(:transaction) {FactoryGirl.create(:transaction)}
  before(:each) do
    assign(:payment, Payment.new(
      :id => "MyString",
      :type => "",
      :intent => 1,
      :state => 1,
      :transaction_id => transaction.id,
      :data => ""
    ))
  end

  it "renders new payment form" do
    render

    assert_select "form[action=?][method=?]", person_transaction_sender_payments_path(transaction_id: transaction.id, person_id: transaction.author.id), "post" do

      assert_select "input#payment_id[name=?]", "payment[id]"

      assert_select "input#payment_type[name=?]", "payment[type]"

      assert_select "input#payment_intent[name=?]", "payment[intent]"

      assert_select "input#payment_state[name=?]", "payment[state]"

      assert_select "input#payment_transaction_id[name=?]", "payment[transaction_id]"

      assert_select "input#payment_data[name=?]", "payment[data]"
    end
  end
end
