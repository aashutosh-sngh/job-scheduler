# Use the official Maven image with OpenJDK 21 for building the project
FROM maven:3.8.4-openjdk-21 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files for the Maven build
COPY pom.xml .
COPY src ./src

# Build the Spring project
RUN mvn clean install -Dmaven.test.skip

# Use the official Tomcat image with OpenJDK 21
FROM tomcat:9-jdk21

# Set the working directory inside the Tomcat container
WORKDIR /usr/local/tomcat/webapps

# Copy the built WAR file from the Maven image to the Tomcat container
COPY --from=builder /app/target/job-scheduler.war .

# Expose the port that the Tomcat server will run on
EXPOSE 8080

# Start Tomcat and deploy the application
CMD ["catalina.sh", "run"]
