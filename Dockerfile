FROM node:18-slim

WORKDIR /opt

COPY ./fonts/* /usr/share/fonts

RUN apt-get update && apt-get install -y xvfb fontconfig && fc-cache -f

COPY ./package.json /opt/package.json
RUN npm install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

CMD [ "sh", "/opt/run.sh" ]
