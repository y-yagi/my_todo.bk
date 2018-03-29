Sequel.migration do
  change do
    create_table(:todos) do
      primary_key :id
      String :content
      DateTime :deadline
    end
  end
end
