# CMITS - Configuration Management for Information Technology Systems
# Based on <https://github.com/afseo/cmits>.
# Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require 'rspec-puppet'
require 'puppetlabs_spec_helper/puppet_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
   c.module_path = File.join(fixture_path, 'modules')
   c.manifest_dir = File.join(fixture_path, 'manifests')
end

shared_context "with tmpdir", :with_tmpdir => true do
  around(:each) do |example|
    Dir.mktmpdir { |tmpdir|
      @tmpdir = tmpdir
      example.run
    }
  end
  let(:tmpdir) { @tmpdir }
end
