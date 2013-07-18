namespace :db do
  desc "create sample data of users"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  user = User.create!(name: "Example User",
                      email: "example@railstutorial.org",
                      password: "foobar",
                      password_confirmation: "foobar")
  user.toggle!(:admin)

  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"

    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  User.all(limit: 6).each do |u|
    50.times do
      content = Faker::Lorem.sentence
      u.microposts.create!(content: content)
    end
  end
end

def make_relationships
  user = User.first
  User.all[2, 51].each do |u|
    user.follow!(u)
    u.follow!(user)
  end
end
