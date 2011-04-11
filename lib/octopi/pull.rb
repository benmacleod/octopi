module Octopi
  class Pull < Base
    include Resource
    attr_accessor :repository, :title, :head, :votes, :number, :position, :gravatar_id, :issue_updated_at,
            :user, :body, :comments, :diff_url, :updated_at, :issue_user, :patch_url, :issue_created_at,
            :labels, :html_url, :state, :base
    resource_path "/pulls/:id"
    find_path "/pulls/:query"

    def self.find_all(options={})
      ensure_hash(options)
      user, repo = gather_details(options)
      states = [options[:state]] if options[:state]
      states ||= ["open", "closed"]
      pulls = []
      states.each do |state|
        validate_args(user => :user, repo.name => :repo)
        pulls << super(user, repo.name, state)
      end
      pulls.flatten.each { |p| p.repository = repo }
    end

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
