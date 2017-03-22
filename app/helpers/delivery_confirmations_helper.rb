module DeliveryConfirmationsHelper
  def person
    @person ||= Person.where("id = ? or username = ?", params[:person_id], params[:person_id]).first
  end
  def transaction
    @transaction ||= Transaction.find(params[:transaction_id])
  end
  def delivery_confirmation
    delivery_confirmation_args = {
      person: person,
      transaction: transaction
    }.merge(
      delivery_confirmation_params({confirmation_number: params[:confirmation_number]})
    )
    @delivery_confirmation ||= DeliveryConfirmation.new(delivery_confirmation_args)
  end

  # Only allow a trusted parameter "white list" through.
  def delivery_confirmation_params(alternative={})
    params.fetch(:delivery_confirmation, alternative).permit(
      :confirmation_number
    )
  end

end
