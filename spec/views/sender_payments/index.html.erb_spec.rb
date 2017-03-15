require 'rails_helper'

RSpec.describe "payments/index", type: :view do
  before(:each) do
    assign(:payments, [
      Payment.create!(
        :id => "Id",
        :type => "Type",
        :intent => 2,
        :state => 3,
        :transaction_id => 4,
        :data => ""
      ),
      Payment.create!(
        :id => "Id",
        :type => "Type",
        :intent => 2,
        :state => 3,
        :transaction_id => 4,
        :data => ""
      )
    ])
  end

  it "renders a list of payments" do
    render
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
