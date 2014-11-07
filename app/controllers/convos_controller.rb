class ConvosController < ApplicationController

  def create
    @convo = Convo.create!(convos_params)
    render json: @convo, status: 201
  rescue
    render json: { error: "Convo not created" }, status: 400
  end

  private
  
  def convos_params
    params.require(:convo).permit(:thread_convo_id, :sender_user_id, :recipient_user_id, :subject_line, :body, :state)
  end

end