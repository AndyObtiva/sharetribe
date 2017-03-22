class DeliveryConfirmationsController < ApplicationController
  include DeliveryConfirmationsHelper
  def new
    redirect_to person_transaction_delivery_confirmation_path(transaction_id: transaction.id, person_id: person.id) if transaction.confirmed_delivery?
    # just render
  end
  def show
    # just render
  end
  def create
    unless transaction.confirm_delivery!(delivery_confirmation.confirmation_number)
      flash.now[:error] = "Confirmation number is invalid! Please try again."
      render action: :new
    else
      render action: :show
    end
  end
end
