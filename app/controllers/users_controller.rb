class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy, update_eligibility_status ]

  # GET /users or /users.json
  def index
    @users = User.limit(100).order('updated_at DESC')
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_user_acc_detail
  end

  # GET /users/1/edit
  def edit
  end

  def update_eligibility_status
    @user.credibility_detail.update(approved_user: params[:status] == 'approve')
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { render :show, status: :ok, location: @user }
    end
  end
  

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :pan_card_no, :aadhar_card_no,
        user_acc_detail_attributes: [
          :user_id,
          :account_number,
          :ifsc,
          :inflow,
          :outflow
        ])
    end
end
