# Repo to show dependency testing using Docker

## Building and running docker files
Repo has small boilerplate code for a python package that requires the Python version to be >=3.8.
Dockerfile has arguments for python version that can be set over the command line

Docker has various stages, the first of which is building an environment out of the Dockerfile. This environment is called the docker image. Images only contain the library installation and definition of requirements, but don't run any of your package code.

From the dockerfile, the first two lines specify the base image. It will by default use Python3.8.

```dockerfile
ARG PY_VERSION=3.8
FROM python:${PY_VERSION}
```

The next 3 lines in the dockerfile will copy your code to a specified location in the image.

```dockerfile
ARG WORKSPACE_DIR=/workspace/application
COPY . ${WORKSPACE_DIR}
WORKDIR ${WORKSPACE_DIR}
```

The last line defines the command that will be ran when the CONTAINER is started:
```dockerfile
ENTRYPOINT ["pip", "install", "."]
```
It attempts to install the package inside of the container.

To build this dockerfile into an image, we can use the following command:
```console
foo@bar:~$ docker build -t <my_project_name:my_version> . --build-arg PY_VERSION=3.8
```
This will do the following:
- Build the image using python version 3.8
- Tag the image with the <my_project_name:my_version> tag, so we can easily reference it later


To create a container out of this image, we can use the following command:
```console
foo@bar:~$ docker run <my_project_name:my_version>
```

Which will create the environment specified in the image, and run the entrypoint command, attempting to install the package.

## Integration tests
To do integration tests, we can test whether our package is installable in the python versions we say we support (>=3.8).

To do so, we can create a multitude of docker images with different python version and try to install our package in them.

We can do so by using the build and run commands specified above:

```console
foo@bar:~$ docker build -t dummy_project:2.7 --build-arg PY_VERSION=2.7
foo@bar:~$ docker build -t dummy_project:3.7 --build-arg PY_VERSION=3.7
foo@bar:~$ docker build -t dummy_project:3.8 --build-arg PY_VERSION=3.8
foo@bar:~$ docker build -t dummy_project:3.9 --build-arg PY_VERSION=3.9
foo@bar:~$ docker build -t dummy_project:3.10 --build-arg PY_VERSION=3.10
```

We can see an overview of the created images:
```console
foo@bar:~$ docker images dummy_project
```

We can now test whether our package can be installed in the different python environments:
```console
foo@bar:~$ docker run dummy_project:3.8 //will succeed
foo@bar:~$ docker run dummy_project:2.7 //will fail
```

Alternatively, we can use the `integration_tests.sh` script which executes these commands for you. 

