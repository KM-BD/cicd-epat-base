# first stage
FROM openjdk:21-ea-oracle AS builder

WORKDIR /app

COPY mvnw .
COPY mvnw.cmd .
COPY .mvn .mvn
COPY src src
COPY pom.xml .
RUN ./mvnw package -DskipTests=true

# second stage
FROM openjdk:21-ea-oracle

WORKDIR /runningapp

#Copy from previous build, the jar file. why 2 stage? 1st stage has source code exposed.
#if ppl download ur image, they will have ur code.
#with a 2nd stage, we are copying the compiled byte code into runningapp folder
# first stage is deleted.
# 2 stage prevent source code from being leaked.

COPY --from=builder /app/target/d13revision-0.0.1-SNAPSHOT.jar .

ENV SERVER_PORT=8080

EXPOSE ${SERVER_PORT}

CMD ["java", "-jar", "d13revision-0.0.1-SNAPSHOT.jar"]
