FROM selenium/node-base:4

USER root

WORKDIR /opt

COPY ./fonts/* /usr/share/fonts

RUN apt-get update && apt-get -qqy install nodejs npm libatk-bridge2.0-0 libgtk-3-dev libdbus-glib-1-de

COPY ./package.json /opt/package.json
RUN npm install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

CMD [ "sh", "/opt/run.sh" ]
