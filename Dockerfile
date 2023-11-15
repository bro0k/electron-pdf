FROM node:18-slim

WORKDIR /opt

RUN apt-get update && apt-get install -y xvfb fontconfig && fc-cache -f

COPY ./fonts/* /usr/share/fonts

COPY ./package.json /opt/package.json
RUN npm yarn -g
RUN yarn

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/
COPY ./node_modules/ /opt/node_modules/

CMD [ "sh", "/opt/run.sh" ]
