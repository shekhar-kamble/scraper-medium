class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|
      t.string :creator
      t.string :title
      t.string :details
      t.string :bloghtml
      t.string :response
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
