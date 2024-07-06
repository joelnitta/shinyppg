FROM rocker/shiny:4.4.0

# Install git
RUN apt-get update && apt-get install -y git

# Install shiny app
RUN install2.r pak

RUN R -q -e 'pak::pak(c("devtools", "joelnitta/shinyppg"))'

# Copy the start script to the image
COPY shiny-start.sh /usr/bin/shiny-start.sh

# Ensure the start script has execute permissions
RUN chmod +x /usr/bin/shiny-start.sh

# Start the application
CMD ["/usr/bin/shiny-start.sh"]