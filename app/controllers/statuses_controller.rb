class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :create, :update, :destroy, :edit]

  def index
    @statuses = Status.all
  end

  def show
  end

  def new
    @status = Status.new
  end

  def edit
    if @status.user != current_user
      redirect_to root_path, alert: "You can't edit this status, it ain't yours!"
    end
  end

  def create
    @status = current_user.statuses.new status_params
    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: "Status was successfully created." }
        format.js
      else
        render action: 'new'
      end
    end
  end

  def update
    if @status.user == current_user
      if @status.update status_params
        redirect_to @status, notice: "Status was successfully updated."
      else
        render action: 'edit'
      end
    else
      redirect_to root_path, alert: "You attempted to update a status that is not yours"
    end
  end

  def destroy
    if @status.user == current_user
      @status.destroy
      respond_to do |format|
        format.html { redirect_to statuses_url }
        format.js
      end
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find params[:id]
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The status you are looking for cannot be found."
      redirect_to root_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:content)
    end
end