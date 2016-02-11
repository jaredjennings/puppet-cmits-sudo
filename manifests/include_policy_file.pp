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
# \subsection{Including policy files}
#
# RHEL 6 has sudo 1.8, which supports \verb!#includedir!. To make sudo
# pay attention to a new file in the \verb!sudoers.d! directory, we
# need do nothing. But Snow Leopard only has sudo 1.7.0, so we must
# \verb!#include! each sudo policy file.
#
# This defined resource type does whatever is necessary to make sudo
# pay attention to a file we've placed in the \verb!sudoers.d!.

define sudo::include_policy_file($ensure='present', $sudoers='', $sudoers_d='') {
    require sudo
    include sudo::params

    $d_sudoers = $sudoers ? {
        ''      => $sudo::params::sudoers,
        default => $sudoers,
    }
    $d_sudoers_d = $sudoers_d ? {
        ''      => $sudo::params::sudoers_d,
        default => $sudoers_d,
    }

# sudo supported the #includedir directive as of 1.7.2. But some
# versions of Mac OS X had older sudo than that. It's safe to
# avoid the use of #includedir, but if it's possible to use, it's
# easier to read and maintain.
#
# It would be more robust to ask sudo what version it is on this box
# than to research when each operating system got sudo 1.7.2---but the
# output of sudo -V seems to be more complicated than a single number
# in some cases.
    $can_includedir = $osfamily ? {
      'RedHat' => true, # since RHEL5
      'CentOS' => true, # since CentOS 5
      'Fedora' => $operatingsystemrelease ? {
        # Fedora 13 had sudo 1.7.2
        /^1[3-9]/ => true,
        /^[2-9][0-9]/ => true,
        default => false,
      },
      'Debian' => $operatingsystemrelease ? {
        # squeeze had 1.7.4
        /^[6789]/ => true,
        default => false,
      },
      'Ubuntu' => $operatingsystemrelease ? {
        # precise had 1.8.3
        /^1[2-9]\..*/ => true,
        default => false,
      },
      'Darwin' => $operatingsystemrelease ? {
        # https://en.wikipedia.org/wiki/Darwin_%28operating_system%29#Release_history
        /^15\..*/ => true, # El Capitan has sudo 1.7.10
        /^14\..*/ => true,
        /^13\..*/ => true, # Mavericks has sudo 1.7.10
        # Lion and Mountain Lion unknown
        /^10\..*/ => false, # Snow Leopard is why all this code got written
        default   => false,
      },
      default  => false,
    }

    Augeas {
      context => "/files/${d_sudoers}",
      incl => "${d_sudoers}",
      lens => 'Sudoers.lns',
    }

    if ! $can_includedir {
      case $ensure {
        'absent': {
          augeas { "sudoers_exclude_${name}":
            changes => [
                        "rm #include[.='${d_sudoers_d}/${name}']",
                        ],
          }
        }
        default: {
          augeas { "sudoers_include_${name}":
            changes => [
                        "set #include[last()+1] '${d_sudoers_d}/${name}'",
                        ],
            onlyif => "match \
            #include[.='${d_sudoers_d}/${name}'] size == 0",
          }
        }
      }
    }
}
