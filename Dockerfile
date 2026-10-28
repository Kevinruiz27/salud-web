FROM openjdk:26-slim

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Instalar curl y dependencias para descargar Tomcat 10
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Descargar e instalar Apache Tomcat 10.1.34
RUN mkdir -p "$CATALINA_HOME" \
    && curl -fSL https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.34/bin/apache-tomcat-10.1.34.tar.gz -o tomcat.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm tomcat.tar.gz

# Desactivar puerto 8005 de shutdown para Render
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/g' $CATALINA_HOME/conf/server.xml

# Limpiar aplicaciones por defecto y copiar tu archivo WAR
RUN rm -rf $CATALINA_HOME/webapps/*
COPY ROOT.war $CATALINA_HOME/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
