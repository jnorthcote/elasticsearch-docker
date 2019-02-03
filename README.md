# elasticsearch-docker
Customised docker image with parameterised fields for elasticsearch.yml

1. Fill in Dockerfile 
	1. Replace ES_JAVA_OPTS accordingly
	2. XPACK_SECURE_URL_SLACK

> docker build --tag=elasticsearch-custom . 

To test that it works:
Note: For Production you want ulimit memlock to be unlimited
> docker run -p 9200:9200 -p 9300:9300 --ulimit memlock=-1:-1 elasticsearch-custom:latest

For development:
> docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch-custom:latest


Deployed to dockerhub as
> docker login
> docker tag elasticsearch-custom:latest herbertyeungservian/elasticsearch:6.6.0
> docker push herbertyeungservian/elasticsearch:6.6.0
