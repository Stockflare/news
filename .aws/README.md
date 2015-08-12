# AWS Cloudformation

Launches the News Website with a Public facing load balancer.

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
  * `DB_ORM`
  * `DATABASE_CONNECTION`
0. On the instance, run the following command to reset and seed the database:
  ```
  docker run -e DB_ORM=<db_orm> -e DATABASE_CONNECTION=<database_connection> <container> bundle exec rake db:reset
  ```
  ```
  docker run -e DB_ORM=<db_orm> -e DATABASE_CONNECTION=<database_connection> <container> bundle exec rake db:seed[/stockflare/db/seeds/list.csv]
  ```

### Further Migrations

0. Follow all the instructions for the First Launch, but swap instruction 5. for the following command:
  ```
  docker run -e DB_ORM=<db_orm> -e DATABASE_CONNECTION=<database_connection> <container> bundle exec rake db:migrate
  ```
