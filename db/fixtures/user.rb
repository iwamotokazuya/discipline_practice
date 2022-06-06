if User.exists?(1)
  User.update(id: 1, name: 'guest', email: 'guest@example.com', password: 'password', password_confirmation: 'password')
else
  User.create!(id: 1, name: 'guest', email: 'guest@example.com', password: 'password', password_confirmation: 'password')
end