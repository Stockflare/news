class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :access_token, null: false, index: true
      t.string :refresh_token
      t.string :token_type, null: false
      t.time :expires_at, null: false
      t.integer :expires_in, null: false
      t.timestamps null: false
    end
  end
end
