# Site documentation

The documentation for this image/repository is written in markdown and built by [MkDocs](https://www.mkdocs.org/) into a documentation website hosted at [Read the Docs](https://readthedocs.org/). [Here is general information about writing MkDocs markdown](https://www.mkdocs.org/user-guide/writing-your-docs/) and [specifics for the Material theme used](https://squidfunk.github.io/mkdocs-material/reference/).

!!! note
    The README.md rarely needs to be modified and only serves as a brief introduction to the project.

The documentation source is maintained in the [docs](https://github.com/itzg/docker-minecraft-server/tree/master/docs) folder and is organized into sections by directory and files. Look through the existing content to determine if an existing file should be updated or a new file/directory added.

It will be very helpful to view the rendered documentation as you're editing. To do that run the following from the top-level directory:

```shell
docker compose -f docker-compose-mkdocs.yml -p mkdocs up
```

You can access the live documentation rendering at <http://localhost:8000>.