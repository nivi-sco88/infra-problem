FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    inetutils-ping

RUN apt-get install -y curl && \
    curl -o /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x /usr/local/bin/lein

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV LEIN_HOME=/root/.lein

# Display installed versions
RUN java -version && \
    python3 --version && \
    lein version

WORKDIR /project/webapp

# Install git
RUN apt-get update && apt-get install -y git

# Clone the GitHub repository
RUN git clone https://github.com/nivi-sco88/infra-problem.git .

# Run any build commands specific to your project
RUN pwd
RUN make libs
RUN make test
RUN make clean all

ENTRYPOINT [ "/bin/bash" ]


