require 'rails_helper'

RSpec.describe "payments/edit", type: :view do
  let(:transaction) {FactoryGirl.create(:transaction)}
  before(:each) do
    @payment = assign(:payment, Payment.create!(
      :id => "MyString",
      :type => "SenderPayment",
      :intent => 1,
      :state => 1,
      :transaction_id => transaction.id,
      :data => ""
    ))
  end

  it "renders the edit payment form" do
    render
    assert_select "form[action=?][method=?]", person_transaction_sender_payment_path(@payment, transaction_id: transaction.id, person_id: transaction.author.id), "post" do

      assert_select "input#payment_id[name=?]", "payment[id]"

      assert_select "input#payment_type[name=?]", "payment[type]"

      assert_select "input#payment_intent[name=?]", "payment[intent]"

      assert_select "input#payment_state[name=?]", "payment[state]"

      assert_select "input#payment_transaction_id[name=?]", "payment[transaction_id]"

      assert_select "input#payment_data[name=?]", "payment[data]"
    end
  end
end
