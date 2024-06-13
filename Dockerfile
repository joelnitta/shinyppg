FROM rocker/shiny:4.4.0

# Install git
RUN apt-get update && apt-get install -y git

RUN install2.r pak

RUN R -q -e 'pak::pak("joelnitta/shinyppg")'

CMD git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pteridogroup/ppg.git /home/shiny/ppg

# Clone the repository when the container starts
# CMD git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pteridogroup/ppg.git /path/to/repo && \
#     Rscript -e 'shiny::runApp("/path/to/your/shiny/app")'
# docker run -e GITHUB_USER=joelnitta -e GITHUB_TOKEN=your-personal-access-token -p 3838:3838 your-docker-image
