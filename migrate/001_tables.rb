Sequel.migration do
  change do
    create_table(:todos) do
      primary_key :id
    end
  end
end
