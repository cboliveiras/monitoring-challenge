# Monitoring Challenge

Welcome to the Monitoring Challenge! You can set up the platform either with Docker or locally. Choose the method that suits your preferences and requirements.

## Set Up with Docker

To set up the Monitoring Challenge using Docker, follow these steps:

1. Install Docker on your machine if you haven't already. Refer to the Docker documentation for detailed installation instructions: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

2. Clone the Monitoring Challenge repository from GitHub:

```git clone git@github.com:cboliveiras/monitoring-challenge.git```

3. If you don't have access to the Github repository, download the .zip file and proceed to step 4.

4. Navigate to the project directory:

```cd monitoring-challenge/challenge_2```

5. Build the Docker image:

```docker-compose build```

1. Create the database and run the migrations:

```docker-compose run web rake db:drop db:create db:migrate```

7. Run the Docker container:

```docker-compose up```

1. The Monitoring Challenge should now be accessible at [http://localhost:3000](http://localhost:3000)


2.  If you want, open a bash session inside the container to run the transaction_generator script:

```docker exec -it challenge_2_web_1 bash```

## Set Up Locally

To set up the Monitoring Challenge locally, follow these steps:

1. Install Ruby 2.7.4 or later on your machine. You can use a version manager like RVM or rbenv to manage your Ruby installations.

2. Clone the Monitoring Challenge repository from GitHub:

```git clone git@github.com:cboliveiras/monitoring-challenge.git```

3. If you don't have access to the Github Repository, download the .zip file and proceed to step 4.

4. Navigate to the project directory:

```cd monitoring-challenge/challenge_2```

5. Install the required gems:

```bundle install```

6. The database.yml file is originally configured to use Docker. If you want to run the application locally, you have to update to:

```
default: &default
  adapter: postgresql
  encoding: unicode

development:
  <<: *default
  database: monitoring_development

test:
  <<: *default
  database: monitoring_test
```

Or just comment lines 4-9.

7. Set up the database:

```rails db:create db:migrate```

8. Start the Rails server:

```rails s```

9. The Monitoring Challenge should now be accessible at [http://localhost:3000](http://localhost:3000)


## Insert data to Database

To insert transactions_1.csv and transactions_2.csv files to our database, run the following commands:

### Transactions 1

```
rails runner -e development "TransactionDataLoader.load_transactions(Rails.root.join('data', 'transactions_1.csv'), { 'time' => :time, 'status' => :status, 'f0_' => :count })"
```

### Transactions 2

```
rails runner -e development "TransactionDataLoader.load_transactions(Rails.root.join('data', 'transactions_2.csv'), { 'time' => :time, 'status' => :status, 'f0_' => :count })"
```

Done. Now we have all data in our database.

## Run the script

To execute the script, run it in a Bash shell or inside a docker-container. This script will make calls to the new_transaction endpoint, which inserts randomly generated data for testing the Anomaly Detector service.

Considering you are already at the project directory (monitoring-challenge/challenge_2), run:

```./transaction_generator.sh```

It will take about 4 min to run. At the same time, you can follow the alerts at [http://localhost:3000/alert_monitoring](http://localhost:3000/alert_monitoring).

## Postman Collection

To test the endpoints, you can use [Postman](https://cboliveiras.postman.co/workspace/New-Team-Workspace~1b824ad1-9e36-4ad8-a727-9110ae009b69/collection/18541010-862099a5-053e-4554-a021-a20090debd85?action=share&creator=18541010). Alternatively, you can access them directly at
- [http://localhost:3000/alerts](http://localhost:3000/alerts) or
- [http://localhost:3000/alert_monitoring](http://localhost:3000/alert_monitoring).

On the last one you will find a graph displaying the number of alerts over time, which is automatically refreshed every 10 seconds.

### It's up to you whether you want to test the application by running the script or by manually entering data through the endpoint :)
