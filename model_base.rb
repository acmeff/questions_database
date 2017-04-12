class ModelBase
  def self.find_by_id(id, table_name)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL
    data.map { |datum| self.class.new(datum) }
  end

  def self.all(table_name)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    data.map { |datum| self.class.new(datum) }
  end

  def save
    if @id
      command = update_str
    else
      command = insert_str
    end

    QuestionsDatabase.instance.execute(command)
    @id = QuestionsDatabase.instance.last_insert_row_id unless @id
  end

  def update_str
    col_names = self.instance_variables
    col_names.push(col_names.shift)
    col_names.map! { |name| name.to_s[1..-1] }
    sql_command = "UPDATE #{@@table_name} SET "

    col_names.each_with_index do |name, idx|
      if idx + 1 == col_names.length
        sql_command << "WHERE #{name} = ?"
      else
        sql_command << "#{name} = ?"
      end
    end

    sql_command
  end

  def question_marks(n)
    Array.new(n, "?").join(', ')
  end

  def insert_str
    col_names = self.instance_variables
    col_names.shift
    col_names.map! { |name| name.to_s[1..-1] }
    "INSERT INTO #{@@table_name} (#{col_names.join(', ')}) VALUES (#{question_marks(col_names.length)})"
  end
end
