class PasswordsController < ApplicationController
  def new
  end

  def create
    if school = School.find_by_email(params[:email])
      new_password = school.reset_password
      PasswordResetNotifier.password_reset(school, new_password).deliver
      redirect_to root_path, notice: notice
    else
      flash.now[:alert] = alert
      render :new
    end
  end

  def edit
    @password = Password.new
  end

  def update
    @password = Password.new(params[:password].merge(user: current_user))

    if @password.save
      redirect_to current_user, notice: notice
    else
      render :edit
    end
  end
end
