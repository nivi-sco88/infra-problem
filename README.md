# Let's Begin !!!
 
## CI/CD using Terraform, kubernetes, docker, Azure cloud and Github Actions
 
### Pre-requiste:
 
#### For Code Repository :-
 
Create a account in Github & check in the provided source code
 
----
 
##### For Infrastructure :-
 
Azure Account - For Infrastructure & Deployment
 
----
 
##### For Image Repository :-
 
Use Docker Hub
 
----
 
##### To test the application on local machine, you need to have below packages:-
 
Visual Studio - Code Editor
 
Docker Desktop
 
Minikube
 
JDK 8
 
Clojure
 
Leiningen
 
Terraform
 
 
### CI/CD Workflow

 ![Infra_Problem](https://github.com/nivi-sco88/infra-problem/assets/156317432/daf74964-1d28-4980-aaf9-5cbd61f572fb)


 
### Steps To follow for Build and Deployment
 
Step 1 : Register an App in Azure under App Registrations [twapp]

Step 2 : Create a Secret for that application.

Step 3 : Copy Client ID , Tenant ID , Client Secret and Subscription ID.

Step 4 : Add copied IDs from Step 3 in GitHub Repository Secrets under repo Settings.

Step 5 : Add Docker Hub Credentials in Github Repository Secrets under repo Settings.

Step 6 : Create storage account & Container in Azure to store Terraform state file.

Step 7 : Add Azure Storage Secret to ithub Repository Secrets under repo Settings.
 
### Run Github Actions workflows in below sequence:

1] Docker Build

2] Create Azure Infra

3] Deploy Quotes

4] Deploy Newsfeed

Note: After deployment of quotes and newsfeed service please check and update the URLs provided in frontend.yaml

5] Deploy Frontend

6] Destroy Infra (Optional)

### To access the application check the external IP of the frontend service

----
# DevOps Assessment

This project contains three services:

* `quotes` which serves a random quote from `quotes/resources/quotes.json`
* `newsfeed` which aggregates several RSS feeds together
* `front-end` which calls the two previous services and displays the results.

## Prerequisites

* Java
* [Leiningen](http://leiningen.org/) (can be installed using `brew install leiningen`)

## Running tests

You can run the tests of all apps by using `make test`

## Building

First you need to ensure that the common libraries are installed: run `make libs` to install them to your local `~/.m2` repository. This will allow you to build the JARs.

To build all the JARs and generate the static tarball, run the `make clean all` command from this directory. The JARs and tarball will appear in the `build/` directory.

### Static assets

`cd` to `front-end/public` and run `./serve.py` (you need Python3 installed). This will serve the assets on port 8000.

## Running

All the apps take environment variables to configure them and expose the URL `/ping` which will just return a 200 response that you can use with e.g. a load balancer to check if the app is running.

### Front-end app

`java -jar front-end.jar`

*Environment variables*:

* `APP_PORT`: The port on which to run the app
* `STATIC_URL`: The URL on which to find the static assets
* `QUOTE_SERVICE_URL`: The URL on which to find the quote service
* `NEWSFEED_SERVICE_URL`: The URL on which to find the newsfeed service
* `NEWSFEED_SERVICE_TOKEN`: The authentication token that allows the app to talk to the newsfeed service. This should be treated as an application secret. The value should be: `T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX`

### Quote service

`java -jar quotes.jar`

*Environment variables*

* `APP_PORT`: The port on which to run the app

### Newsfeed service

`java -jar newsfeed.jar`

*Environment variables*

* `APP_PORT`: The port on which to run the app

