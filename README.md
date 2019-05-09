# docker-openstudio-rnotebook

[![Build Status](https://travis-ci.org/NREL/docker-openstudio-rnotebook.svg?branch=master)](https://travis-ci.org/NREL/docker-openstudio-rnotebook)

Base image for using RStudio/RMarkdown Notebooks in OpenStudio Server.

### Build

Installing the [docker tool-kit](https://docs.docker.com/engine/installation/) version 17.03.1 or later, as described in the linked documentation. Once the tool-kit is installed and activated, run the command `docker build . -t"nrel/openstudio-rnotebook"`. This will initiate the build process for the docker container. Any updates to this process should be implemented through the [Dockerfile](./Dockerfile) in the root of this repo. 

### Run

To run the container with no security, build or pull the container and execute:
`docker run -p 127.0.0.1:8787:8787 -e DISABLE_AUTH=true nrel/openstudio-rnotebook`

# Known Issues

Please submit issues on the project's [Github](https://github.com/nrel/docker-openstudio-rnotebook) page. 
