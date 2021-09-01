# sets the parent image as ubuntu (official base image for Ubuntu 20.04 Focal)
FROM ubuntu

### Installation of node.js using NVM

# version of the node.js runtime to be installed
ENV NODE_VERSION=14.17.6

# download package information from all configured sources
RUN apt-get update

# download and install the curl package
RUN apt-get -y install curl

# download NVM installation script using curl and run using bash
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# directory in which the nvm.sh script resides
ENV NVM_DIR=/root/.nvm 

# load nvm and install the appropriate version of node.js runtime
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}

# use the appropriate node.js version
RUN . "$NVM_DIR/nvm.sh" && nvm use ${NODE_VERSION}

# set the appropriate node.js version as default
RUN . "$NVM_DIR/nvm.sh" && nvm alias default ${NODE_VERSION}

# add the node executable to the PATH environment variable
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# print the node and npm versions to verify installation
RUN node --version
RUN npm --version

### Installation of sqlite3

# download and install the sqlite3 package
RUN apt-get -y install sqlite3 libsqlite3-dev

### Setting up and running the web app

# create and set the /usr/src/app directory as CWD
WORKDIR /usr/src/app

# copy package.json and package-lock.json files from the host to the image
COPY package*.json ./ 

# download and install the npm packages listed in package.json
RUN npm install

# copy contents of the current directory in host (excluding `node_modules` directory) to CWD of the image
COPY . .

# create the data folder if it does not already exist
RUN mkdir -p data

# expose port 3000 of the container to the host
EXPOSE 3000

# run the node.js server
CMD [ "node", "index.js" ]