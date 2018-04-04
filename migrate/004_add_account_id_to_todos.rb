Sequel.migration do
  change do
    alter_table(:todos) do
      add_foreign_key :account_id, :accounts, type: :Bignum
    end
  end
end
