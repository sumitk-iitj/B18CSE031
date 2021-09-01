FROM ubuntu

ENV NODE_VERSION=14.17.6

RUN apt-get update
RUN apt-get -y install curl
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN apt-get -y install sqlite3 libsqlite3-dev

WORKDIR /usr/src/app

COPY package*.json ./ 
RUN npm install

COPY . .
RUN mkdir -p data

EXPOSE 3000

CMD [ "node", "index.js" ]