class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :ip
      t.float :rating, default: 0
      t.references :user, index: true,  foreign_key: true

      t.timestamps
    end
    add_index :posts, :ip
    add_index :posts, :rating
  end
end
