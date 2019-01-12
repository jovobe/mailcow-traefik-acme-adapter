# mailcow-traefik-acme-adapter
An adapter to use [traefik](https://traefik.io/) generated acme certs in [mailcow](https://mailcow.email/).

## background
traefik provides the possibility to automatically generate acme certs with [letsencrypt](https://letsencrypt.org/). These certs are stored in a proprietary format (located in a file called `acme.json`). Sadly mailcow does not offer a native solution to import certs from that format. This adapter is designed to fill that gap. It will look for new certs in the `acme.json`, export them and will send them to mailcow.

## how this adapter works
1. A watcher on the `acme.json` file is created
2. If the `acme.json` file changes, all including certs will be extracted inside the container
3. The cert and key from the configured domain will be copied to the configured location
4. All extracted certs inside the container are deleted
5. The relevant services from mailcow are restarted, to load the new certs

## setup with docker-compose
Add the following service inside your `docker-compose.yml` and replace the config values:
```yaml
certdumper:
  image: jovobe/mailcow-traefik-acme-adapter:latest
  container_name: traefik_mailcow_cert_adapter
  depends_on:
    # Here should be the name of your traefik service
    - name-of-traefik-service-goes-here
  restart: always
  volumes:
    # This volume mounts the traefik root folder into the container for access
    # to the `acme.json` file
    - /absolute/path/to/traefik-root:/traefik:ro

    # This volume mounts the mailcow ssl folder into the container. By default
    # this should be in your mailcow folder under "data/assets/ssl"
    - /absolute/path/to/mailcow-dockerized/data/assets/ssl:/ssl-share:rw

    # This volume mounts the docker socket into the container to enable docker
    # control from inside the container
    - /var/run/docker.sock:/var/run/docker.sock:rw
  environment:
    # This variable should contain the domain with which you are running
    # mailcow
    - DOMAIN=your-domain-goes-here.tld
```
