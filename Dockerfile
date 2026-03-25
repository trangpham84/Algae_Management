# ─────────────────────────────────────────────────────────────────────────────
#  Dockerfile — Algae Management System
#  Builds a self-contained Tomcat 10 + WAR image for Render deployment.
#  All dependencies are bundled inside the WAR by Maven (no "provided" scope
#  for servlet-api when running standalone — see note below).
# ─────────────────────────────────────────────────────────────────────────────

# ── Stage 1: Build the WAR with Maven ────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /build

# Copy dependency descriptor first to leverage Docker layer cache
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Stage 2: Run on Tomcat 10 ─────────────────────────────────────────────────
FROM tomcat:10.1-jdk21-temurin

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR as ROOT so the app is served at "/"
COPY --from=builder /build/target/Algae_Management-1.0-SNAPSHOT.war \
     /usr/local/tomcat/webapps/ROOT.war

# Render sets PORT; Tomcat default is 8080 — make it configurable
ENV PORT=8080
EXPOSE 8080

# Override Tomcat connector port at startup using sed so it respects $PORT
CMD ["/bin/bash", "-c", \
     "sed -i 's/port=\"8080\"/port=\"'$PORT'\"/' /usr/local/tomcat/conf/server.xml && \
      catalina.sh run"]
