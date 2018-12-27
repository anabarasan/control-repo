plan test (
  TargetSpec $nodes,
  String $content = 'Hello World',
) {
  $nodes.apply_prep
  apply($nodes) {
    file { '/tmp/test':
      ensure  => present,
      content => $content,
    }
  }
}
