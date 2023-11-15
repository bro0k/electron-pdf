FROM node:18

WORKDIR /opt

COPY ./fonts/* /usr/share/fonts

COPY ./package.json /opt/package.json
RUN npm install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

CMD [ "sh", "/opt/run.sh" ]
