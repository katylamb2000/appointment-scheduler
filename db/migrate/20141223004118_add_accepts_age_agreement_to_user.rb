class AddAcceptsAgeAgreementToUser < ActiveRecord::Migration
  def change
    add_column :users, :accepts_age_agreement, :boolean, default: false
  end
end
