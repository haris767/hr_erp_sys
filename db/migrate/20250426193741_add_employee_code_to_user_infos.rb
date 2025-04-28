class AddEmployeeCodeToUserInfos < ActiveRecord::Migration[8.0]
  def change
    add_column :user_infos, :employee_code, :string
  end
end
