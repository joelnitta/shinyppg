# Dockerfile for deploying app on ploomber

FROM rocker/shiny:4.4.0

WORKDIR /app

# Install git
RUN apt-get update && apt-get install -y git

# Install shiny app
RUN install2.r pak

# Work-around to disable docker cache from this point on:
# write out a timestamp that will change with each build
ADD http://worldtimeapi.org/api/timezone/Etc/UTC.txt /timestamp

RUN R -q -e 'pak::pak("joelnitta/shinyppg")'

# Set up app.R
COPY app.R /app/app.R

# Clone ppg repo on startup
ENTRYPOINT /bin/bash -c "Rscript app.R"
