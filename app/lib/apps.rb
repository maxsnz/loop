class Apps < Settingslogic
  source "#{Rails.root}/config/settings.#{Rails.env}.yml"
end
