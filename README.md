# shinyppg

A Shiny app to edit the Pteridophyte Phylogeny Group (PPG) database

## Deploying

The app is deployed using <https://ploomber.io/>

More details to come...

## Development

To develop the app within the docker container, run:

(variables `GITHUB_USER` and `GITHUB_TOKEN` must be provided for git functions to work)

```
docker run --rm -it \
  -v ${PWD}:/srv/shiny-server \
  -w /srv/shiny-server \
  -e USERID=$(id -u) \
  -e GROUPID=$(id -g) \
  -e GITHUB_USER=${GITHUB_USER} \
  -e GITHUB_TOKEN=${GITHUB_TOKEN} \
  -p 3838:3838 \
  joelnitta/shinyppg:latest
```

Inside the container, run `/usr/bin/shiny-server` to start the shiny app.

Navigate to localhost:3838/ to access the app.

Kill the shiny-server with ctrl+c and re-run it as necessary during development to refresh with the latest code.

Another terminal window (or VS Code session) can be opened inside the container for development.