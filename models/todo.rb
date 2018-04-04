class Todo < Sequel::Model
  plugin :json_serializer

  many_to_one :account
end
