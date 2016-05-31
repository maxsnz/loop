ActiveAdmin.register Player do
  config.sort_order = "name_asc"
  config.filters = false
  config.batch_actions = true
  actions :all, except: [ :new, :create ]
  menu label: "Участники"

  index do
    # column :n, sortable: true

    {player: :name, score: :score, attempts: false, picture: false}.each do |name, sortable|
      column(name, sortable: sortable) do |model|
        PlayerDecorator.new(model).send(name)
      end
    end
    actions
  end


  controller do
    include PermitConcern, NoShowConcern
  end
end
