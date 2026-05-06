# frozen_string_literal: true

foreman_rake 'db:migrate' do
  path '/usr/share/foreman'
end
