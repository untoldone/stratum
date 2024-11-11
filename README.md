# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Configuration for Brother ADS-2700W for development

In `./collector/keys` complete the following:

1. `ssh-keygen -t ed25519 -f ssh_host_ed25519_key -N ''`
2. `ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key -N ''`
3. Upload the `ssh_host_rsa_key.pub` file to the Brother scanner admin site (on Network=> Security => Server Public Key site)
4. Generate and download a public key (on Network=> Security => Client Key Pair). Name the file `authorized_keys`
5. Create a SFTP profile on Scan => Scan to FTP/SFTP/Network
6. Configure a profile on Scan => Scan to FTP/SFTP/Network Profile
   1. Host Address should be your local dev IP
   2. Username should be `collector`
   3. Auth. Method should be `Public Key`
   4. Client key Pair the key created on the public key page
   5. Server Public key the key created on the server public key page
   6. Store directory `/input`
   7. Port number `2222`

If this fails, it is useful to start the docker image locally (command in `Procfile.dev` and adding `-e DEBUG_MODE=true` to the collector service)
