class profile::agents {

  $agent_ips_query = @("EOF")
  fact_contents[value] {
    path = ["ec2_metadata", "public-ipv4"] and
    resources { type="Class" and title ~ 'Role::Agent*' }
  }
| EOF

  $number_of_agents_query = @("EOF")
  nodes[count()] {
    resources { type="Class" and title ~ 'Role::Agent*' }
  }
| EOF

  $agents_count = puppetdb_query($number_of_agents_query)[0]['count']
  $agent_ips_array = puppetdb_query($agent_ips_query).map |$fact_content| { $fact_content['value'] }
  $agent_ips = join($agent_ips_array, "\n")

  $file_content = @("EOF")
Number of Agents = ${agents_count}
$agent_ips
| EOF

  file { '/tmp/agent_ips':
    content => $file_content,
    ensure  => present,
  }

}