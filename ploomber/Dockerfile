# Dockerfile for deploying app on ploomber

FROM rocker/shiny:4.4.0

WORKDIR /app

# Install git
RUN apt-get update && apt-get install -y git

# Install shiny app
RUN install2.r pak

RUN R -q -e 'pak::pak("joelnitta/shinyppg")'

# Set up git
RUN git config --global user.email "ourPPG@googlegroups.com" && \
  git config --global user.name "PPG Bot"

# Set up app.R
COPY app.R /app/app.R

# Clone ppg repo on startup
ENTRYPOINT /bin/bash -c "git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pteridogroup/ppg.git /ppg && Rscript app.R"
