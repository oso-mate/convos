class ConvosController < ApplicationController

  # POST /convo
  def create
    @convo = Convo.create!(create_params)

    render json: { convo: @convo }, status: 201
  rescue
    render json: { error: "Convo not created" }, status: 400
  end

  # GET /convos
  def index
    render json: { error: "Parameter missing" }, status: 400 and return if index_params_keys.empty?

    @user = User.find(params[index_params_keys.first])
    @convos = Convo.where(index_conditions)
    
    render json: { convos: @convos }
  rescue
    render json: { error: "Convos not found" }, status: 404
  end

  # GET /convos/:convo_id
  def show
    @convo = Convo.find(params[:convo_id])

    render json: { convo: @convo }, status: 200
  rescue
    render json: { error: "Convo not found" }, status: 404
  end

  # PATCH /convo/:convo_id
  def update
    @convo = Convo.find_by(convo_id: params[:convo_id])
    render json: { error: "Convo not found" }, status: 404 and return unless @convo.present?

    @convo.update! update_params
    render json: { convo: @convo }, status: 200
  rescue
    render json: { error: "Convo not updated" }, status: 400
  end

  private
  
  def create_params
    params.require(:convo).permit(:thread_convo_id, :sender_user_id, :recipient_user_id, :subject_line, :body, :state)
  end

  def index_conditions
    if index_params_keys.include?("user_id")
      ["(sender_user_id = ? OR recipient_user_id = ?)", @user.id, @user.id]
    else
      ["#{index_params_keys.first} = ?", @user.id]
    end
  end

  def index_params_keys
    params.keys.select { |k| %W[user_id sender_user_id receiver_user_id].include?(k) }
  end

  def update_params
    params.require(:convo).permit(:state)
  end

end