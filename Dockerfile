#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM ubuntu:trusty
EXPOSE 8081

# Env variables
ENV SCALA_VERSION 2.12.2
ENV SBT_VERSION 0.13.15

# Scala expects this file
# RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

RUN apt-get update && apt-get install -y curl

# Install Scala
## Piping curl directly in tar
RUN \
          curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
            echo >> /root/.bashrc && \
              echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install sbt
              RUN \
                    curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
                      dpkg -i sbt-$SBT_VERSION.deb && \
                        rm sbt-$SBT_VERSION.deb && \
                          apt-get update && \
                            apt-get install sbt && \
                              sbt sbtVersion

# Define working directory
CMD /usr/lib/jvm/java-8-oracle/bin/java -Dfile.encoding=UTF8 -Djline.terminal=none -Dsbt.log.noformat=true -Dsbt.global.base=/tmp/sbt-global-pluginstub -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M -classpath /home/kigaita/.IntelliJIdea2017.2/config/plugins/Scala/launcher/sbt-launch.jar xsbt.boot.Boot "project brave_assignment" run


