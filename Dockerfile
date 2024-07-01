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

RUN echo "library(dwctaxon)" >> /srv/shiny-server/app.R && \
  echo "library(shinyppg)" >> /srv/shiny-server/app.R && \
  echo "ppg_app()" >> /srv/shiny-server/app.R

# Copy the entrypoint script into the container
COPY app.R /app/

# Make the entrypoint script executable
ENTRYPOINT /bin/bash -c "git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pteridogroup/ppg.git /ppg && Rscript app.R"

# Clone the repository when the container starts
# CMD git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pteridogroup/ppg.git /ppg && \
#   /usr/bin/shiny-server

# docker run --rm -dt -e GITHUB_USER=joelnitta -e GITHUB_TOKEN=your-personal-access-token -p 3838:3838 joelnitta/shinyppg:latest
# docker run --rm -v ${PWD}:/wd -w /wd -dt -e USERID=$(id -u) -e GROUPID=$(id -g) -e GITHUB_USER=joelnitta -e GITHUB_TOKEN=your-personal-access-token -p 3838:3838 joelnitta/shinyppg:latest

