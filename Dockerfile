FROM rocker/shiny:4.4.0

# Install git
RUN apt-get update && apt-get install -y git

# Install shiny app
RUN install2.r pak

RUN R -q -e 'pak::pak(c("devtools", "joelnitta/shinyppg"))'

# Set up git
RUN git config --global user.email "ourPPG@googlegroups.com" && \
  git config --global user.name "PPG Bot"

# Set up app.R

# Clone the repository when the container starts
CMD git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pteridogroup/ppg.git /ppg
