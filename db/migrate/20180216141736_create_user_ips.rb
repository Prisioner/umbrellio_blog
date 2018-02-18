class CreateUserIps < ActiveRecord::Migration[5.1]
  def change
    create_table :user_ips do |t|
      t.string :ip

      t.timestamps
    end
    add_index :user_ips, :ip, unique: true
  end
end
