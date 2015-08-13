namespace :db do
  namespace :mongoid do
    desc 'Create collections'
    task create_collections: [:environment, :load_models] do
      ::Mongoid.models.select do |model|
        model.try(:create_collection_tailable!)
      end
    end
  end
end
