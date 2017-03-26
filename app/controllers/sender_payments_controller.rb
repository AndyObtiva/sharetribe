class SenderPaymentsController < ApplicationController
  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_make_a_payment")
  end

  before_action :set_person
  before_action :set_transaction
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  def index
    @payments = SenderPayment.all
  end

  # GET /payments/1
  def show
  end

  # GET /payments/new
  def new
    if @transaction.sender_payment.present?
      redirect_to sender_payment_person_transaction_path(person_id: params[:person_id], id: params[:transaction_id])
    else
      @payment = SenderPayment.new
    end
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  def create
    @payment = SenderPayment.new(payment_params.merge(
        intent: :authorize,
        transaction_id: params[:transaction_id]
      ))
    @payment.return_url = sender_payment_person_transaction_url(id: params[:transaction_id], person_id: params[:person_id])
    @payment.cancel_url = request.env['HTTP_REFERER']


    if @payment.save
      redirect_to sender_payment_person_transaction_path(id: params[:transaction_id], person_id: params[:person_id]), notice: 'Please confirm payment details and click on PayPal Check out button at the bottom once ready.'
    else
      render :new
    end
  end

  # PATCH/PUT /payments/1
  def update
    if @payment.update(payment_params)
      respond_to do |format|
        format.html {redirect_to sender_payment_person_transaction_path(id: params[:transaction_id], person_id: params[:person_id]), notice: 'Payment was successfully updated.'}
        format.json {render json: @payment.data}
      end
    else
      respond_to do |format|
        format.html {render :edit}
        format.json {render json: {'errors': @payment.errors}}
      end
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    redirect_to :back, notice: 'Payment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.where("id = ? or username = ?", params[:person_id], params[:person_id]).first
    end

    def set_transaction
      @transaction = Transaction.find_by(id: params[:transaction_id])
    end

    def set_payment
      @payment = SenderPayment.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_params
      params.require(:sender_payment).permit(
        # :id,
        # :type,
        # :intent,
        # :state,
        # :transaction_id,
        # :data,
        :recipient_email,
        :recipient_phone,
        :payer_id
      )
    end
end
