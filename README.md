# apache-spark

Docker image for Apache Spark standalone

## How to use

Example:

Build the Docker image.

```{bash}
docker build -t <your Docker Hub ID>/apache-spark .
```
Create a simple cluster with master and one worker.

```{bash}
docker run -d --name spark-master -e 'MASTER=true' <your Docker Hub ID>/apache-spark:latest
docker run -d --name spark-worker01 --link spark-master:master <your Docker Hub ID>/apache-spark:latest
```

The "master" in the link should be fixed, since it is used internally in the container.
