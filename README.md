page_title: About the Docker documentation tools
page_description: Introduction to the Docker documentation tools
page_keywords: docker, introduction, documentation, about, technology, understanding, Dockerfile

# Docker documentation tools

This repository contains the HTML theme, and the build tools for
generating [the Docker documentation site](https://docs.docker.com).

It can be used to view and check the changes to your repository's
documentation in preparation for merging into the Official Docker
documentation.

## How to set use it in your repository

This tooling is currently used by:

- [Docker](https://github.com/docker/docker)
- [Docker Compose](https://github.com/docker/fig)
- [Docker Machine](https://github.com/docker/machine)
- [Docker Swarm](https://github.com/docker/swarm)

So there are working examples you can compare with.

Each project uses a documentation specific `Dockerfile` to import the markdown
files and images into the Docker image's `/docs/source` directory.

Then there is a `mkdocs.yml` file, which is placed into the `/docs/` directory.
For the base project, `docker/docker`, it will replace the default
`/dos/mkdocs.yml` file, and for all projects that are going to be added to that
`https://docs.docker.com` documentation set, should be renamed as
`/docs/mkdocs-<project>.yml` so that it can be imported into the main site.

The repositories with a `Makefile` will build using `make docs`, the others have
either a `script/docs` or `docs/build.sh` script to build a preview of their local
documentation.