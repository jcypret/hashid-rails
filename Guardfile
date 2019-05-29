guard_options = {
  all_after_pass: false,
  all_on_start: false,
  cmd: "bundle exec rspec"
}

guard :rspec, guard_options do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch("spec/spec_helper.rb")  { "spec" }
end
