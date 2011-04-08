module Octopi
  class Pull < Base
    include Resource
    resource_path "/pulls/:id"
    find_path "/pulls/:query"

    def self.find(options={})
      ensure_hash(options)
      # Do not cache issues, as they may change via other means.
      @cache = false
      user, repo = gather_details(options)

      validate_args(user => :user, repo => :repo)
      pull = super user, repo, options[:number]
      pull.repository = repo
      pull
    end
  end
end
