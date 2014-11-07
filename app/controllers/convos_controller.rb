class ConvosController < ApplicationController

  # POST /convo
  def create
    @convo = Convo.create!(create_params)

    render json: @convo, status: 201
  rescue
    render json: { error: "Convo not created" }, status: 400
  end

  # PATCH /convo
  def update
    @convo = Convo.find_by(convo_id: params[:convo_id])
    render json: { error: "Convo not found" }, status: 404 and return unless @convo.present?

    @convo.update! update_params
    render json: @convo, status: 200
  rescue
    render json: { error: "Convo not updated" }, status: 400  
  end

  private
  
  def create_params
    params.require(:convo).permit(:thread_convo_id, :sender_user_id, :recipient_user_id, :subject_line, :body, :state)
  end

  def update_params
    params.require(:convo).permit(:state)
  end

end