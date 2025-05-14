class CreateFileModels < ActiveRecord::Migration[7.0]
  def change
    create_table :file_models do |t|
      t.string :name
      t.string :audio_path

      t.timestamps
    end
  end
end
