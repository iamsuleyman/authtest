class AddAppUriToDoorkeeperApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :oauth_applications, :app_uri, :string, null: true
  end
end
