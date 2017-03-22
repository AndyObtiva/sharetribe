class DeliveryConfirmation
  include ActiveModel::Model
  attr_accessor :confirmation_number, :transaction, :person
end
