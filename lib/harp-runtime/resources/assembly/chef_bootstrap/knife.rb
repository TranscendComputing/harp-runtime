log_level                :info
log_location             STDOUT
node_name                '<node_name>'
client_key               '<client_key_path>'
validation_client_name   '<validation_client_name>'
validation_key           '<validation_key_path>'
chef_server_url          '<chef_server_url>'
cache_type               'BasicFile'
cache_options( :path => 'checksums' )
cookbook_path [ 'cookbooks' ]