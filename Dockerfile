FROM eclipse-temurin:11-jdk-focal

# Update package lists and install necessary packages
RUN apt-get update \
    && apt-get install -y unzip curl \
    && adduser --uid 1001 --home /home/sunbird --disabled-password --gecos "" sunbird \
    && mkdir -p /home/sunbird/ \
    && chown -R sunbird:sunbird /home/sunbird/

# Add and unzip the notification service
ADD ./notification-service-1.0.0-dist.zip /home/sunbird/ 
RUN unzip /home/sunbird/notification-service-1.0.0-dist.zip -d /home/sunbird/ 

# Change ownership of the extracted files
RUN chown -R sunbird:sunbird /home/sunbird

# Switch to the non-root user
USER sunbird

# Expose port
EXPOSE 9000

# Set working directory and default command
WORKDIR /home/sunbird/
CMD java -XX:+PrintFlagsFinal $JAVA_OPTIONS -Dlog4j2.formatMsgNoLookups=true -Dplay.server.http.idleTimeout=180s -cp '/home/sunbird/notification-service-1.0.0/lib/*' play.core.server.ProdServerStart /home/sunbird/notification-service-1.0.0
