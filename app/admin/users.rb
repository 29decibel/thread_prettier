ActiveAdmin.register User do
  index do
    column :id
    column :email
    column :invite_code
    default_actions
  end
  
end
