FROM selenium/node-base:4

USER root

RUN apt-get update && apt-get -qqy install nodejs npm libatk-bridge2.0-0 libgtk-3-dev

COPY ./fonts/* /usr/share/fonts

USER 1200

WORKDIR /opt

RUN sudo chmod -R 775 /opt \
  && sudo chgrp -R 0 /opt \
  && sudo chmod -R g=u /opt

COPY ./package.json /opt/package.json
RUN npm install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

CMD [ "sh", "/opt/run.sh" ]
