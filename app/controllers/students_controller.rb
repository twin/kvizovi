# encoding: utf-8

class StudentsController < ApplicationController
  def index
    @students = current_school.students
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])

    if @student.save
      log_in!(@student)
      redirect_to new_game_path, notice: "Uspješno si se registrirao."
    else
      render :new
    end
  end

  def show
    @student = current_student
  end

  def edit
    @student = current_student
  end

  def update
    @student = current_student

    if @student.update_attributes(params[:student])
      redirect_to @student, notice: "Profil je uspješno izmijenjen."
    else
      render :edit
    end
  end

  def delete
    @student = current_student
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    if school_logged_in?
      current_school.students.destroy(params[:id])
      redirect_to students_path, notice: "Učenik je uspješno izbrisan."
    else
      @student = current_student

      if @student.authenticate(params[:student][:password])
        @student.destroy
        log_out!
        redirect_to root_path, notice: "Tvoj korisnički račun je uspješno izbrisan."
      else
        flash.now[:alert] = "Lozinka nije točna."
        render :delete
      end
    end
  end
end
