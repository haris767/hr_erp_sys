class AddDefaultValuesToUserInfos < ActiveRecord::Migration[8.0]
  def change
    change_column_default :user_infos, :gender, 1 # default to male (1)
    change_column_default :user_infos, :grade, 1  # default to grade 'a' (1)
  end
end
