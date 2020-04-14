# AUTHOR:           Brian Ball
# DESCRIPTION:      Rstudio Server Container. Modified from rocker/rstudio to use nrel/openstudio-r as base, ubuntu base, work on OS-Server.
# TO_BUILD_AND_RUN: docker run -p 127.0.0.1:8787:8787 -e DISABLE_AUTH=true
FROM nrel/openstudio-r:3.5.2-1
LABEL MAINTAINER Brian Ball <brian.ball@nrel.gov>

#link gtar to tar for devtools::install_github to work
RUN ln -s /bin/tar /bin/gtar

ARG GITHUB_PAT 

# Add in the additional R packages
#ADD /install_packages.R install_packages.R
#RUN Rscript install_packages.R
RUN R -e "options(warn=2); install.packages('loo', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('loo', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('inline', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('inline', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('Rcpp', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('Rcpp', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('coda', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('coda', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('BH', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('BH', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('RcppEigen', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('RcppEigen', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('StanHeaders', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('StanHeaders', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('RInside', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('RInside', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('RUnit', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('RUnit', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('ggplot2', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('ggplot2', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('gridExtra', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('gridExtra', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('knitr', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('knitr', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('rmarkdown', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('rmarkdown', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('pkgbuild', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('pkgbuild', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); Sys.setenv(MAKEFLAGS = '-j2'); install.packages('rstan', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('rstan', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"
RUN R -e "options(warn=2); install.packages('fields', repos=c('http://cloud.r-project.org','http://cran.r-project.org'), quiet=TRUE); if (!require('fields', character.only = TRUE)){ print('Error installing package, check log'); quit(status=1) }"

ENV RSTUDIO_VERSION=1.2.1335
ARG S6_VERSION
ARG PANDOC_TEMPLATES_VERSION
ENV S6_VERSION=${S6_VERSION:-v1.21.7.0}
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV PANDOC_TEMPLATES_VERSION=${PANDOC_TEMPLATES_VERSION:-2.6}

## Download and install RStudio server & dependencies
## Attempts to get detect latest version, otherwise falls back to version given in $VER
## Symlink pandoc, pandoc-citeproc so they are available system-wide
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    dialog \
    file \
    git \
    libapparmor1 \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    procps \
    python-setuptools \
    sudo \
    wget \
    libclang-dev \
    libclang-3.8-dev \
    libobjc-6-dev \
    libclang1-3.8 \
    libclang-common-3.8-dev \
    libllvm3.8 \
    libobjc4 \
    libgc1c2 \
  && RSTUDIO_URL="http://download2.rstudio.org/server/trusty/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb" \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Need to configure non-root user for RStudio
  && useradd rstudio \
  && echo "rstudio:rstudio" | chpasswd \
	&& mkdir /home/rstudio \
	&& chown rstudio:rstudio /home/rstudio \
	&& addgroup rstudio staff \
  ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
  &&  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  ## configure git not to request password each time
  && git config --system credential.helper 'cache --timeout=3600' \
  && git config --system push.default simple \
  ## Set up S6 init system
  && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
          \n## load /etc/environment vars first: \
  		  \n for line in $( cat /etc/environment ) ; do export $line ; done \
          \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/services.d/rstudio/run \
  && echo '#!/bin/bash \
          \n rstudio-server stop' \
          > /etc/services.d/rstudio/finish \
  && mkdir -p /home/rstudio/.rstudio/monitored/user-settings \
  && echo 'alwaysSaveHistory="0" \
          \nloadRData="0" \
          \nsaveAction="0"' \
          > /home/rstudio/.rstudio/monitored/user-settings/user-settings \
  && chown -R rstudio:rstudio /home/rstudio/.rstudio

COPY userconf.sh /etc/cont-init.d/userconf

## running with "-e ADD=shiny" adds shiny server
COPY add_shiny.sh /etc/cont-init.d/add
COPY disable_auth_rserver.conf /etc/rstudio/disable_auth_rserver.conf
COPY pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper

EXPOSE 8787

## automatically link a shared volume for kitematic users
VOLUME /home/rstudio/kitematic

CMD ["/init"]