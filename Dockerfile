# Build Stage
FROM openjdk:11-jdk-slim AS build

# Install curl
RUN apt-get update && apt-get install -y curl findutils zip

WORKDIR /app
COPY . .

# Create lib and classes directories
RUN mkdir -p web/WEB-INF/lib
RUN mkdir -p web/WEB-INF/classes

# Download required dependencies from Maven Central
RUN curl -L -o web/WEB-INF/lib/mysql-connector-j-8.1.0.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.1.0/mysql-connector-j-8.1.0.jar
RUN curl -L -o web/WEB-INF/lib/activation.jar https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar
RUN curl -L -o web/WEB-INF/lib/mail.jar https://repo1.maven.org/maven2/com/sun/mail/javax.mail/1.6.2/javax.mail-1.6.2.jar
RUN curl -L -o web/WEB-INF/lib/commons-io-2.11.0.jar https://repo1.maven.org/maven2/commons-io/commons-io/2.11.0/commons-io-2.11.0.jar
RUN curl -L -o web/WEB-INF/lib/commons-fileupload-1.4.jar https://repo1.maven.org/maven2/commons-fileupload/commons-fileupload/1.4/commons-fileupload-1.4.jar
RUN curl -L -o web/WEB-INF/lib/jstl-1.2.jar https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar

# Download Tomcat APIs just for compiling
RUN curl -L -o /tmp/servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

# Compile Java source files
RUN find src/java -name "*.java" > sources.txt
RUN javac -cp "web/WEB-INF/lib/*:/tmp/servlet-api.jar" -d web/WEB-INF/classes @sources.txt

# Package into a WAR file
WORKDIR /app/web
RUN zip -r /app/ROOT.war *

# Run Stage
FROM tomcat:9-jre11-slim
# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR to Tomcat
COPY --from=build /app/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
