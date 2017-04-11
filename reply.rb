class Reply
  attr_accessor :question_id, :parent_reply, :user_id, :body

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    data.map { |datum| Reply.new(datum) }.first
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply = options['parent_reply']
    @user_id = options['user_id']
    @body = options['body']
  end

  def create
    raise "#{self} already there ya dum dum" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_reply, @user_id, @body)
      INSERT INTO
        replies (question_id, parent_reply, user_id, body)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end
