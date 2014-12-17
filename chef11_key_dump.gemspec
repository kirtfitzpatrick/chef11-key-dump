Gem::Specification.new do |s|
  s.name        = 'chef11-key-dump'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Dumps Chef11 keys to json."
  s.description = "Dumps an Open Source Chef 11 server's key data for transform and import into a Chef 12 server."
  s.authors     = ["Kirt Fitzpatrick"]
  s.email       = 'kirt@chef.io'
  s.files       = %w[ bin/chef11-key-dump lib/chef11_key_dump.rb ]
  s.homepage    = 'https://rubygems.org/gems/chef11-key-dump'
  s.executables << 'chef11-key-dump'
  s.add_runtime_dependency "sequel"
  s.add_runtime_dependency "pg"
  s.add_runtime_dependency "json"
end
