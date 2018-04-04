class Account < Sequel::Model
  one_to_many :todos
end
