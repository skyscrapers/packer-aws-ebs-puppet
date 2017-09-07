Racker::Processor.register_template do |t|

  # Define the variables
  t.variables = {
    'aws_region'        => 'eu-west-1',
    'aws_instance_type' => 't2.micro',
    'aws_source_ami'    => '',
    'environment'       => '',
    'project'           => '',
    'function'          => '',
    'aws_ec2_profile'   => '',
    'module_paths'      => '',
    'root_volume_size'  => '',
    'root_volume_type'  => '',
    'manifest_file'     => '',
    'hiera_config_path' => '',
    'share_accounts'    => '',
    'hiera_path'        => ''
  }

  # Define the builders
  t.builders['amazon'] = {
    'type'                      => 'amazon-ebs',
    'region'                    => '{{user `aws_region`}}',
    'source_ami'                => '{{user `aws_source_ami`}}',
    'instance_type'             => '{{user `aws_instance_type`}}',
    'iam_instance_profile'      => '{{user `aws_ec2_profile`}}',
    'ssh_username'              => 'ubuntu',
    'ssh_pty'                   => true,
    'ami_name'                  => 'ebs-{{user `project`}}-{{user `function`}}-{{isotime "200601020304"}}',
    'ami_users'                 => '{{user `share_accounts`}}',
    'snapshot_users'            => '{{user `share_accounts`}}',
    'ami_block_device_mappings' => {
      '/dev/sda1' => {
        'device_name'           => '/dev/sda1',
        'volume_size'           => '{{user `root_volume_size`}}',
        'volume_type'           => '{{user `root_volume_type`}}',
        'delete_on_termination' => true
      }
    },
    'run_tags' => {
      'Project'     => 'packer',
      'Environment' => '{{user `environment`}}'
    },
    'tags' => {
      'Project'     => '{{user `project`}}',
      'Environment' => '{{user `environment`}}',
      'Node'        => '{{user `name`}}'
    }
  }

  # Define the provisioners
  t.provisioners = {
    0 => {
      'prepare-hiera' => {
        'type'   => 'shell',
        'inline' => ['rm -Rf /tmp/hiera; mkdir -p /tmp/hiera; chmod 777 /tmp/hiera']
      }
    },
    10 => {
      'apt-updates' => {
        'type'   => 'shell',
        'script' => 'scripts/updates.sh'
      }
    },
    20 => {
      'puppet-install' => {
        'type'   => 'shell',
        'script' => 'scripts/puppet_install.sh'
      }
    },
    30 => {
      'upload-hiera' => {
        'type'        => 'file',
        'source'      => '{{user `hiera_path`}}',
        'destination' => '/tmp/hiera/'
      }
    },
    40 => {
      'puppet-run' => {
        'type'              => 'puppet-masterless',
        'manifest_file'     => '{{user `manifest_file`}}',
        'module_paths'      => '{{user `module_paths`}}',
        'hiera_config_path' => '{{user `hiera_config_path`}}',
        'working_directory' => '/tmp/hiera',
        'facter'            => {
          'function'       => '{{user `function`}}',
          'project'        => '{{user `project`}}',
          'ourenvironment' => '{{user `environment`}}',
          'packerbuild'    => 'true'
        }
      }
    },
    50 => {
      'cleanup' => {
        'type'   => 'shell',
        'script' => 'scripts/cleanup.sh'
      }
    }
  }

  # Define the post-processors
  t.postprocessors['packer-manifest'] = {
    'type'       => 'manifest',
    'output'     => 'packer_manifest.json',
    'strip_path' => true
  }

end
