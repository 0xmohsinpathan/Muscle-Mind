# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fitness.Repo.insert!(%Fitness.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Fitness.Exercises
alias Fitness.Accounts
alias Fitness.Chats

# pull all exercise data

File.read!("priv/repo/list_of_exercises.txt")
|> :erlang.binary_to_term()
|> Enum.uniq()
|> Enum.each(fn workout -> Exercises.create_exercise(workout) end)

# create fake user

{:ok, user_1} =
  Accounts.register_user(%{
    email: "test@test.com",
    password: "test@test.com",
    is_admin: true,
    username: "Admin001",
    name: "Admin"
  })

{:ok, user_2} =
  Accounts.register_user(%{
    email: "test@test1.com",
    password: "test@test1.com",
    is_admin: false,
    username: "puppies-lover",
    name: "Andervrs",
    player_score: "1001"
  })

Accounts.register_user(%{
  email: "test@test2.com",
  password: "test@test2.com",
  is_admin: false,
  username: "Full-stack-developer",
  name: "Alfred",
  player_score: "800"
})

Accounts.register_user(%{
  email: "test@test3.com",
  password: "test@test3.com",
  is_admin: false,
  username: "Captain-America",
  name: "john",
  player_score: "1000"
})

Accounts.register_user(%{
  email: "test@test4.com",
  password: "test@test4.com",
  is_admin: false,
  username: "Rhythm-Rider",
  name: "Einer",
  player_score: "700"
})

Accounts.register_user(%{
  email: "test@test5.com",
  password: "test@test5.com",
  is_admin: false,
  username: "Richie-Rich",
  name: "yusef",
  player_score: "900"
})

Accounts.register_user(%{
  email: "test@test6.com",
  password: "test@test6.com",
  is_admin: false,
  username: "The-Label-Man",
  name: "eddie",
  player_score: "10000"
})

Accounts.register_user(%{
  email: "test@test7.com",
  password: "test@test7.com",
  is_admin: false,
  username: "The-Wizard",
  name: "brook",
  player_score: "5000"
})

Accounts.register_user(%{
  email: "test@test8.com",
  password: "test@test8.com",
  is_admin: false,
  username: "Albert-Einstein",
  name: "steve",
  player_score: "600"
})

Accounts.register_user(%{
  email: "test@test9.com",
  password: "test@test9.com",
  is_admin: false,
  username: "The-Bird-Man",
  name: "marko",
  player_score: "500"
})

Accounts.register_user(%{
  email: "test@test10.com",
  password: "test@test10.com",
  is_admin: false,
  username: "Elixir-Newbie",
  name: "mohsin",
  player_score: "2000"
})

# create fake msg date

{:ok, room} = Chats.create_room(%{name: "random"})

Chats.create_message(%{
  data: "Hello World!",
  user_id: user_2.id,
  room_id: room.id
})

IO.puts("your room: #{room.id}")
