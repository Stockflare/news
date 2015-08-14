# AWS Cloudformation

Launches the News Website with a Public facing load balancer located at news.<hosted zone>

This Cloudformation launches an ECS service that is designed to run inside the CoreOS cluster.

This service publishes its logs to the Kibana cluster that is also hosted inside the VPC. Therefore, the Kibana cloudformation is a dependency.

The image for the ECS Service is retrieved from the Private Docker Registry hosted inside the VPC.

### Dependencies

| Stack | Description |
|---|---|
| environment | Environment Configuration Cloudformation |
| network | Configures the Private VPC and its networking |
| lambda-stack-outputs | Lambda Stack Outputs Cloudformation |
| registry | Private Docker Registry hosted inside the VPC |
| kibana | Kibana Logging Cloudformation |
| coreos | The CoreOS Cluster configured inside the VPC

---

### Parameters

Should be configured from the appropriate configuration file within this folder.

| Parameter | Default | Description |
|---|---|---|
| ServiceName | `null`  | Name that the service will use for its docker containers `-n ...`  |
| ServicePort | `null`  | Port that the service will bind itself to on the instance |
| ServiceImage | `null`  | The image name for the repository, should be `stockflare/api-news-source` |
| ServiceVersion | `null`  | The service version you'd like to launch, typically a git revision. |
| DBName | `null`  | Name of the database to use. Should be non-generic! |
| DBUsername | `null`  | Username that the database will accept connections on |
| DBPassword | `null`  | Password for the database user. |

---

### First Launch

Some manual steps are required for first launch; to setup the database, migrations and seed data.

0. Create the cloudformation and wait for the `ECS::Service` to begin creation.
0. Determine which EC2 instance has been determined to run the service.
0. SSH into the EC2 instance.
0. Look at the ECS Task Definition inside the Console for the following environment variables:
  * `DB_USERNAME`
  * `DB_PASSWORD`
  * `DB_HOST`
  * `DB_PORT`
  * `DB_NAME`
0. On the instance, run the following command to reset and seed the database:
  ```
  docker run -e RAILS_ENV=production -e DB_USERNAME=username -e DB_PASSWORD=password -e DB_HOST=host -e DB_PORT=port -e DB_NAME=name <container> bundle exec rake db:create
  ```
  ```
  docker run -e RAILS_ENV=production -e DB_USERNAME=username -e DB_PASSWORD=password -e DB_HOST=host -e DB_PORT=port -e DB_NAME=name <container> bundle exec rake db:migrate
  ```

### Further Migrations

0. Follow instructions 1-4 from the first launch, then run the following command:
  ```
  docker run -e RAILS_ENV=production -e DB_USERNAME=username -e DB_PASSWORD=password -e DB_HOST=host -e DB_PORT=port -e DB_NAME=name <container> bundle exec rake db:migrate
  ```
  ```
