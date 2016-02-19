# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
class sudo(
  $sudoers=$sudo::params::sudoers,
  $sudoers_d=$sudo::params::sudoers_d,
  $users_to_all=$sudo::params::users_to_all,
  $groups_to_all=$sudo::params::groups_to_all,
  $require_password=$sudo::params::require_password,
) inherits sudo::params {

  class { 'sudo::config':
    sudoers   => $sudoers,
    sudoers_d => $sudoers_d,
  }

  require sudo::auditable::policy

  $no_password = $require_password ? {
    true => false,
    false => true,
  }
  sudo::auditable::for { $users_to_all:
    no_password => $no_password,
    require => Class['sudo::config'],
  }
  sudo::auditable::for_group { $groups_to_all:
    no_password => $no_password,
    require => Class['sudo::config'],
  }
}
