class QuizPlay
  NO_ANSWER = "ROFLMAO"

  def initialize(store)
    @store = store
  end

  ############
  # Actions
  ############

  def start!(quiz_snapshot, students)
    @store[:student_ids]         = students.map(&:id).join(",")
    @store[:quiz_snapshot_id]    = quiz_snapshot.id
    @store[:quiz_id]             = quiz_snapshot.quiz.id
    @store[:question_ids]        = quiz_snapshot.questions.map(&:id).join(",")
    @store[:question_categories] = quiz_snapshot.questions.map(&:category).join(",")
    @store[:question_answers]    = ""

    @store[:current_student]  = 0
    @store[:current_question] = 0

    @store[:begin] = Time.now.to_i

    self
  end

  def save_answer!(answer)
    unless current_question[:answer] != nil
      answers = @store[:question_answers].split("`")
      answers[current_question[:number] - 1] =
        if answer.nil? or (answer.is_a?(String) and answer.empty?)
          NO_ANSWER
        else
          answer.to_s
        end
      @store[:question_answers] = answers.join("`")
    end
  end

  def next_question!
    unless current_question[:answer] == nil or current_question == questions.last
      next_student!
      @store[:current_question] = Integer(@store[:current_question]) + 1
    end
  end

  def next_student!
    students_count = @store[:student_ids].split(",").count
    @store[:current_student] = (Integer(@store[:current_student]) + 1) % students_count
  end

  def finish!
    @store[:end] = Time.now.to_i
  end

  ############
  # Reading
  ############

  def questions_count
    question_ids.count
  end

  def current_question
    question(Integer(@store[:current_question]))
  end

  def questions
    questions_count.times.map { |i| question(i) }
  end

  def students_count
    student_ids.count
  end

  def students
    students_count.times.map { |i| student(i) }
  end

  def current_student
    student(Integer(@store[:current_student]))
  end

  def quiz
    {id: Integer(@store[:quiz_id])}
  end

  def quiz_snapshot
    {id: Integer(@store[:quiz_snapshot_id])}
  end

  def begin_time
    Time.at(Integer(@store[:begin]))
  end

  def end_time
    Time.at(Integer(@store[:end]))
  end

  def interrupted?
    questions.last[:answer] == nil
  end

  def over?
    questions.last[:answer] != nil
  end

  def to_h
    {
      students:  students,
      quiz:      quiz,
      questions: questions,
      begin:     begin_time,
      end:       end_time,
    }
  end

  private

  def question_ids
    @store[:question_ids].split(",").map do |id|
      Integer(id)
    end
  end

  def question_answers
    @store[:question_answers].split("`").map.with_index do |answer, i|
      next answer if answer == NO_ANSWER
      case question_categories[i]
      when "boolean"     then {"true" => true, "false" => false}[answer]
      when "association" then answer[2..-3].split(/", "/)
      else                    answer
      end
    end
  end

  def question_categories
    @store[:question_categories].split(",")
  end

  def question(i)
    {number: i + 1, id: question_ids[i], answer: question_answers[i]}
  end

  def student_ids
    @store[:student_ids].split(",").map do |id|
      Integer(id)
    end
  end

  def student(i)
    {number: i + 1, id: student_ids[i]}
  end
end
