require_relative './user'
require 'bcrypt'

class UserRepository

  def all
    sql = 'SELECT id, username, email, password FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])

    users = []

    result_set.each do |value|
      user = User.new

      user.id = value['id']
      user.username = value['username']
      user.email = value['email']
      user.password = value['password']

      users << user

    end

    return users
  end

  def find(id)
    sql = 'SELECT id, username, email, password FROM users WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    user = User.new

    user.id = result_set[0]['id']
    user.username = result_set[0]['username']
    user.email = result_set[0]['email']
    user.password = result_set[0]['password']

    return user

  end

  def find_by_values(email)
    sql = 'SELECT id, username, email, password FROM users WHERE (email = $1);'
    sql_params = [email]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    if result_set.num_tuples.zero?
      return nil
    end

    user = User.new
    user.id = result_set[0]['id']
    user.username = result_set[0]['username']
    user.email = result_set[0]['email']
    user.password = result_set[0]['password']

    return user
  end

  def update_session_id(user_id, session_id)
    sql = 'UPDATE users SET session_id=$1 WHERE id=$2'
    sql_params = [session_id, user_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
  end

  def create(new_user)
    sql = 'INSERT INTO users (username, email, password)
      VALUES ($1, $2, $3);'

    password = BCrypt::Password.create(new_user.password)
    sql_params = [new_user.username, new_user.email, password]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end
end