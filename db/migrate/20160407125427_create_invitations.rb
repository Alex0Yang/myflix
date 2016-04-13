class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :friend_name
      t.string :friend_email
      t.text :message
      t.string :invite_token
      t.integer :user_id
      t.timestamps
    end
  end
end
