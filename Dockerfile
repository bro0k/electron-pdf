FROM selenium/node-base:4

WORKDIR /opt

COPY ./fonts/* /usr/share/fonts

RUN apt-get update && apt-get -y nodejs

COPY ./package.json /opt/package.json
RUN npm install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

CMD [ "sh", "/opt/run.sh" ]
