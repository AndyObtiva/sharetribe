require 'spec_helper'

describe Transaction do
  context 'after save' do
    it 'ensures associated listing gets transaction id' do
      transaction = FactoryGirl.create(:transaction)
      expect(transaction.listing.transaction_process_id).to eq(transaction.id)
      # ensures happens again on listing change
      transaction.update(listing: FactoryGirl.create(:listing))
      expect(transaction.listing.transaction_process_id).to eq(transaction.id)
    end
  end
end
