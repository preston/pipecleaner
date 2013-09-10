class AddUrlSlugs < ActiveRecord::Migration
  def change
  	add_column :pipelines, :slug, :string
  	add_column :stages, :slug, :string
  	add_index :pipelines, :slug, unique: true
  	add_index :stages, :slug, unique: true
  end

  def down
  end
end
