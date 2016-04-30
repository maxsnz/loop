ActiveAdmin.register Result do
  config.sort_order = "created_at_desc"
  # config.filters = true
  filter :player 
  filter :seconds
  actions :all, except: [ :new, :create, :edit ]
  menu label: "Результаты"


  controller do

    def scoped_collection
      # Result.all.where(state: 'correct')
      Result.with_state(Result::DONE).includes :player
      # Result.all
    end
  end


  index do
    # column :n, sortable: true

    {player: 'players.name', score: :score, seconds: :seconds, created_at: :created_at}.each do |name, sortable|
      column(name, sortable: sortable) do |model|
        ResultDecorator.new(model).send(name)
      end
    end
  end

  form partial: "form"

  controller do
    include PermitConcern, NoShowConcern
  end
end
