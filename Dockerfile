FROM node:18-slim

WORKDIR /opt

COPY ./fonts/* /usr/share/fonts

RUN apt-get update && apt-get install -y xvfb fontconfig && fc-cache -f

RUN npm install

COPY . /opt

CMD [ "sh", "/opt/run.sh" ]
