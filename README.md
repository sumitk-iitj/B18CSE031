## Description

Author: Manul Goyal (B18CSE031)

Developed for the course CSL7510 Virtualization and Cloud Computing: Assessment 1, Question 2

## Development Process

### Setting up the web app

1. I created a node.js web server using the express package, and set it to run on the port 3000.

2. I created a new database in sqlite3 named 'employeeDb.sqlite'. The node.js server connects to the database using `sequelize` package.

3. I created a simple front-end using pug (HTML templating engine) and bootstrap.

### Creating the Dockerfile

1. I created a Dockerfile, which works as follows:
    * First, it sets the parent image as `ubuntu`, which means that the current image should be based on the official Ubuntu 20.04 Focal base image.
    * The version of the node.js runtime is specified in the `NODE_VERSION` environment variable.
    * The `apt-get update` command is run to download package information from all configured sources.
    * The `curl` package is downloaded and installed using `apt-get`.
    * The NVM (Node Version Manager) installation script is downloaded using `curl` and run using `bash`.
    * NVM is loaded by running the `/root/.nvm/nvm.sh` script.
    * The appropriate version of node, as specified by `NODE_VERSION` environment variable, is installed and set as default using `nvm`.
    * `sqlite3` database is installed using `apt-get`.
    * The `/usr/src/app` directory is created and set as the current working directory.
    * The `package.json` and `package-lock.json` files are copied from the current directory in host to the working directory in the image.
    * The npm packages listed in `package.json` are downloaded and installed using the `npm install` command.
    * The entire contents of the current directory in host (excluding `node_modules` directory) are copied to the working directory in the image. These are the files corresponding to the web app and the database.
    * The `data` directory is created in the working directory in the image if it does not already exist.
    * The port 3000 (on which the node.js server listens) is exposed to the host.
    * The server is started using the command `node index.js`.
2. A `.dockerignore` file is also created which specifies that the `node_modules` directory and `npm-debug.log` file are excluded while copying the contents to the image.

### Building and running the docker image

Clone the repository and navigate to the repository folder. The following set of commands are executed in a host terminal in the repository directory to build the docker image using the Dockerfile and instantiate the image:

1. Build the docker image from the Dockerfile: \
`docker build . -t b18cse031/vcc-webapp` \
\
This compiles the Dockerfile in the current directory and builds a docker image with the name `b18cse031/vcc-webapp`.

2. Instantiate the image to create a container, bind the port 3000 of the container to port 8080 of the host, and run it in the background: \
`docker run -p 8080:3000 -d b18cse031/vcc-webapp`

3. List the running containers using: \
`docker ps` \
\
You should be able to see the newly created container and that the host port 8080 is being forwarded to container port 3000.

4. Open a web browser and navigate to http://localhost:8080 (or http://0.0.0.0:8080 if it doesn't work). You should be able to see the web app running.

## Features of the web app

- The web app connects to the "employeeDb.sqlite" database in the data folder and displays the contents of the "employees" table. It automatically creates the database and/or the table if they don't exist.
- You can delete an existing employee by clicking on the Delete button next to the corresponding row in the table.
- You can add/update existing employees by clicking on the 'Create' link in the NavBar. To update an existing employee, enter the employee number of the corresponding employee and new values of the other fields as required. To create a new employee, use a new employee number.

