class CreateAdminNotes < ActiveRecord::Migration
  def self.up
  end

  def self.down
    drop_table :admin_notes
  end
end
