class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :add_user_view_path, if: :user_logged_in?
  before_action :save_activity, if: :user_logged_in?
  before_action :force_filling_email, if: :user_logged_in?

  add_flash_types :success, :error, :warning

  protected

  def current_user
    case
    when school_signed_in?  then current_school
    when student_signed_in? then current_student
    end
  end
  helper_method :current_user

  def user_logged_in?
    school_signed_in? or student_signed_in?
  end
  helper_method :user_logged_in?

  def authenticate_user!
    redirect_to root_path, warning: "Niste prijavljeni." if not user_logged_in?
  end

  def authenticate_school!
    redirect_to root_path, warning: "Niste prijavljeni kao škola." if not school_signed_in?
  end

  def authenticate_student!
    redirect_to root_path, warning: "Niste prijavljeni kao učenik." if not student_signed_in?
  end

  def after_sign_in_path_for(resource_or_scope)
    account_path
  end

  def add_user_view_path
    prepend_view_path "app/views/#{current_user.type.pluralize}"
  end

  def save_activity
    LastActivity.for(current_user).save(Time.now)
  end

  def force_filling_email
    if current_user.email.blank? and params[:controller] != "account/profiles"
      redirect_to edit_account_profile_path, warning: "Od sada nadalje nam treba tvoja email adresa, pa molimo da je ispuniš ispod."
    end
  end

  def devise_parameter_sanitizer
    DeviseParameterSanitizer.new(resource_class, resource_name, params)
  end

  def account_path
    case
    when school_signed_in?  then account_quizzes_path
    when student_signed_in? then choose_quiz_path
    end
  end
  helper_method :account_path

  class DeviseParameterSanitizer < Devise::ParameterSanitizer
    def sign_in
      default_params.permit!
    end

    def sign_up
      default_params.permit!
    end

    def account_update
      default_params.permit!
    end
  end
end
