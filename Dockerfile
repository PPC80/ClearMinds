FROM 681989517074.dkr.ecr.us-east-1.amazonaws.com/cobis/cts-cis-cloud:cobis-cloud-cis-microservice-3.2.0-test-concurrent-orchetrations-SNAPSHOT-809e8de
ARG USER=appuser
RUN mkdir -p /opt/cobishome-cis-micro
RUN chmod -R 700 /opt/cobishome-cis-micro
RUN mkdir -p /tmp
RUN addgroup -S appgroup && adduser --shell /sbin/nologin --disabled-password --no-create-home -S $USER -G appgroup
RUN mkdir -p /etc/sudoers.d \
		&& echo "$USER ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
		&& chmod 0440 /etc/sudoers.d/$USER
RUN chown -R $USER:appgroup /tmp
RUN chown -R $USER:appgroup /opt/cobishome-cis-micro
RUN chmod 700 /tmp
USER $USER
COPY target/app.jar /opt
COPY install.xml /opt
RUN ["java","-jar","/opt/app.jar","-file","/opt/install.xml"]
VOLUME /opt/cobishome-cis-micro
VOLUME /tmp
USER root
RUN rm /etc/sudoers.d/$USER
USER $USER
ENTRYPOINT ["java","-cp","/opt/cobis/jar/cobis-cloud-cis-microservice-3.2.0.jar","-Dloader.main=com.cobis.cloud.infra.cis.Application","-DCOBIS_HOME=/opt/cobishome-cis-micro","-Dloader.path=/opt/cobishome-cis-micro/ATM/plugins,/opt/cobishome-cis-micro/ATM/bls","org.springframework.boot.loader.PropertiesLauncher"]