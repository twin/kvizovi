require_relative "../../lib/has_many_questions"

class School < ActiveRecord::Base
  LEVELS = ["Osnovna", "Srednja"]

  has_many :students, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  extend HasManyQuestions
  has_many_questions dependent: :destroy

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :email,    presence: true, uniqueness: true
  validates :place,    presence: true
  validates :region,   presence: true
  validates :level,    presence: true, inclusion: {in: LEVELS}
  validates :key,      presence: true

  def type; "school"; end

  def to_s; name; end

  def primary?;   level == "Osnovna"; end
  def secondary?; level == "Srednja"; end

  def grades
    primary? ? (1..8) : (1..4)
  end
end
