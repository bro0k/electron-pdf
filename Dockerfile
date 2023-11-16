FROM node:18

WORKDIR /opt

RUN apt-get update
# Required for a GUI
RUN apt-get install -y libgbm-dev libgtk-3-0 libatk-bridge2.0-0 libgtkextra-dev libgconf2-dev libnss3 libasound2 libxtst-dev libxss1 libx11-xcb1 xvfb

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/
COPY ./package.json /opt/package.json
COPY ./fonts/* /usr/share/fonts

RUN npm install

CMD [ "sh", "/opt/run.sh" ]
