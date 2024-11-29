# docker file for running the code from the local machine


# Stage 1: Build the application using Maven (Alpine version)
FROM maven:3.8-openjdk-11-slim AS builder

# Set the working directory to /app
WORKDIR /app

# Copy only the necessary files to avoid cache invalidation
COPY pom.xml /app/
COPY src /app/src/

# Build the WAR file (skip tests for faster build)
RUN mvn clean package -DskipTests && \
    # Clean up the Maven cache to reduce the size
    rm -rf ~/.m2/repository

# Stage 2: Deploy the application with Tomcat (Alpine version)
FROM tomcat:9-alpine

# Set the working directory to Tomcat's webapps folder
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file from the build stage to Tomcat as ROOT.war
COPY --from=builder /app/target/app-java-1.0.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 to the outside world (Tomcat default)
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]

# Initially

# REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
# java-tomcat-app   latest    29c6d5c0145b   55 seconds ago   444MB


# END RESULT 

# REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
# java-tomcat-app   latest    a615c8eb7bf8   46 seconds ago   117MB



