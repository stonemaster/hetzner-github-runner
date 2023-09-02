{
  image: "ubuntu-22.04",
  location: $location,
  server_type: $server_type,
  name: $name,
  public_net: {
    enable_ipv4: true,
    enable_ipv6: false
  },
  start_after_create: true,
  user_data: $cloud_init_yml,
}
