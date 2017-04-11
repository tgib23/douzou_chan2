class RenamePicIdColumnToPic < ActiveRecord::Migration[5.0]
  def change
    rename_column :pics, :pic_id, :post_id
  end
end
