namespace :db do
  desc 'Create collections'
  task create: :'mongoid:create'

  namespace :mongoid do
    desc 'Create collections'
    task create: :create_collections

    desc 'Create collections'
    task create_collections: [:environment, :load_models] do
      ::Mongoid.models.select do |model|
        model.try(:create_collection_tailable!)
      end
    end
  end
end
