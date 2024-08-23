FROM eclipse-temurin:11-jdk-focal
RUN apt-get update \
    && apt-get install -y unzip curl \ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && adduser -uid 1001 -home  /home/sunbird/ -disabled-password --gecos "" sunbird \
    && mkdir -p /home/sunbird/ 
ADD ./notification-service-1.0.0-dist.zip /home/sunbird/ 
RUN unzip /home/sunbird/notification-service-1.0.0-dist.zip -d /home/sunbird/ 
RUN chown -R sunbird:sunbird /home/sunbird
USER sunbird
EXPOSE 9000
WORKDIR /home/sunbird/
CMD ["java", "-XX:+PrintFlagsFinal", "$JAVA_OPTIONS","-Dlog4j2.formatMsgNoLookups=true", "-Dplay.server.http.idleTimeout=180s","-cp", "/home/sunbird/notification-service-1.0.0/lib/*"," play.core.server.ProdServerStart", "/home/sunbird/notification-service-1.0.0"]
