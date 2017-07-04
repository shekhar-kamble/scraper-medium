class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|
      t.string :creator
      t.string :title
      t.string :details
      t.xml :bloghtml
      t.string :tags, array: true, default: []
      t.xml :response, array: true, default: []

      t.timestamps
    end
  end
end
