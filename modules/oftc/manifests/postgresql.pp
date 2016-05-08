class oftc::postgresql {
  ferm::port { 'postgresql':
    port => '5432 5433',
  }
}
