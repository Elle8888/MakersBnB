require 'user_repository'

describe UserRepository do

def reset_user_table
    seed_sql = File.read('spec/seeds_users.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
end

before(:each) do
    reset_user_table
end
  it 'list all users' do
    repo = UserRepository.new

    user = repo.all

    expect(user.length).to eq 3
    
    expect(user[0].id).to eq '1'
    expect(user[0].username).to eq  'user1'
    expect(user[0].email).to eq 'name1@email.com'
    expect(user[0].password).to eq 'password1'
    
    expect(user[1].id).to eq  '2'
    expect(user[1].username).to eq  'user2'
    expect(user[1].email).to eq 'name2@email.com'
    expect(user[1].password).to eq 'password2'
  end
  
  it 'finds a single user' do
    repo = UserRepository.new

    user = repo.find(1)

    expect(user.id).to eq '1'
    expect(user.username).to eq 'user1'
    expect(user.email).to eq 'name1@email.com'
    expect(user.password).to eq 'password1'
  end

  it 'creates a new maker with encrypted password' do
    
    repo = UserRepository.new

    new_user = User.new

    new_user.id = '3'
    new_user.username =  'user3'
    new_user.email = 'name3@email.com'
    new_user.password = 'password3'

    repo.create(new_user)

    users = repo.all

    expect(users).to include(
    have_attributes(
      id: new_user.id,
      username: new_user.username,
      email: new_user.email,
      )
    )

    users = repo.find(3)
    password = BCrypt::Password.new(users.password)
    expect(password == new_user.password).to eq false
  end
end