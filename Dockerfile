FROM maven:3.5-jdk-8-alpine as builder
#First we need to clone the connector repo and build the artifact
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh
WORKDIR /opt/aw/dremio/
RUN git clone https://github.com/dremio-hub/dremio-flight-connector.git
WORKDIR /opt/aw/dremio/dremio-flight-connector
COPY pom.xml .
#ADD builder-volume/pom.xml .
RUN mvn clean install
COPY target/*.jar .

FROM dremio/dremio-oss as runner
#Copy the artifacts
WORKDIR /dremio/jars
COPY --from=builder /opt/aw/dremio/*.jar .

# docker run -p 9047:9047 -p 31010:31010 -p 45678:45678 dremio/dremio-oss
