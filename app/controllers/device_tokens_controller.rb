class DeviceTokensController < ApplicationController
  before_action :set_device_token, only: %i[ show edit update destroy ]

  # GET /device_tokens or /device_tokens.json
  def index
    @device_tokens = DeviceToken.all
  end

  # GET /device_tokens/1 or /device_tokens/1.json
  def show
  end

  # GET /device_tokens/new
  def new
    @device_token = DeviceToken.new
  end

  # GET /device_tokens/1/edit
  def edit
  end

  # POST /device_tokens or /device_tokens.json
  def create
    @device_token = DeviceToken.new(device_token_params)

    respond_to do |format|
      if @device_token.save
        format.html { redirect_to @device_token, notice: "Device token was successfully created." }
        format.json { render :show, status: :created, location: @device_token }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @device_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /device_tokens/1 or /device_tokens/1.json
  def update
    respond_to do |format|
      if @device_token.update(device_token_params)
        format.html { redirect_to @device_token, notice: "Device token was successfully updated." }
        format.json { render :show, status: :ok, location: @device_token }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @device_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /device_tokens/1 or /device_tokens/1.json
  def destroy
    @device_token.destroy!

    respond_to do |format|
      format.html { redirect_to device_tokens_path, status: :see_other, notice: "Device token was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device_token
      @device_token = DeviceToken.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def device_token_params
      params.require(:device_token).permit(:token, :device_id)
    end
end
