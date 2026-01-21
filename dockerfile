FROM maven:latest AS build
LABEL maintainer="dhaneeshjadhav@gmail.com"
LABEL application="apache-tomcat"
LABEL environment="testing"
# setting the default working directory
WORKDIR /app
# copy source code
COPY . .
# verify maven installation
RUN mvn -version
RUN mvn clean package

#  runtieme stage

FROM tomcat:9.0 
WORKDIR /usr/local/tomcat
# remove the default web apps inside the webapps directory
RUN rm -rf webapps/*
# copy my website into the webapp directory
COPY --from=build /app/website.html  webapps/ROOT/website.html
COPY --from=build /app/target/*.war  webapps/webapp.war
EXPOSE 8080
CMD [ "catalina.sh", "run" ]
