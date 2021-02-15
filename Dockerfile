FROM amazonlinux:2

ENV VERSION_GRADLE=6.8
ENV VERSION_NODE=12.10.0

# Install Curl, Git, OpenSSL (AWS Amplify requirements) and tar (required to install hugo)
RUN touch ~/.bashrc
RUN yum -y update && \
    yum -y install \
    curl \
    git \
    openssl \
    tar \
    wget \
    unzip \
    java-11-amazon-corretto-headless \
    yum clean all && \
    rm -rf /var/cache/yum

# Install Node (AWS Amplify requirement)
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
    nvm install $VERSION_NODE && nvm use $VERSION_NODE && \
    nvm alias default node && nvm cache clear"

#Install Gradle
RUN mkdir /opt/gradle
RUN wget -c https://services.gradle.org/distributions/gradle-6.8-bin.zip
RUN unzip -d /opt/gradle gradle-6.8-bin.zip

# Configure environment
RUN echo export PATH="\
    /root/.nvm/versions/node/${VERSION_NODE}/bin:\
    /opt/gradle/gradle-${VERSION_GRADLE}/bin:\
    JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto.x86_64:\
    $PATH" >> ~/.bashrc && \
    echo "nvm use ${VERSION_NODE} 1> /dev/null" >> ~/.bashrc

RUN curl -sL https://aws-amplify.github.io/amplify-cli/install | bash && $SHELL

ENTRYPOINT ["bash", "-c"]
