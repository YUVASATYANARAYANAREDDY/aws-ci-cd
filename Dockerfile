# Use an official Maven image to build the application
FROM public.ecr.aws/docker/library/maven:3.9.9-amazoncorretto-17-al2023 AS build

# Set the working directory for the build
WORKDIR /app

# Copy the pom.xml and download the dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and package the application
COPY src ./src
RUN mvn -DskipTests package

# Use a lighter image for the runtime
FROM public.ecr.aws/docker/library/openjdk:17-jdk-slim

# Set the working directory for the runtime
WORKDIR /app

# Copy the packaged jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port that the application runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
# FROM public.ecr.aws/docker/library/maven:3.9.9-amazoncorretto-17-al2023
# RUN groupadd spring && useradd -r -m -g spring -s /sbin/nologin spring
# USER spring:spring
# # Set the working directory for the build
# WORKDIR /app
# # Copy the pom.xml and download the dependencies
# COPY pom.xml .
# # RUN mvn dependency:go-offline -B
# # Copy the source code and package the application
# COPY src ./src
# RUN mvn -DskipTests package
# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} app.jar
# EXPOSE 8080
# ENTRYPOINT ["java","-jar","target/*.jar"]
