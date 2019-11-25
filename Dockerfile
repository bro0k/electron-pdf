FROM iojs:3.0

WORKDIR /opt

RUN apt-get update && \
  apt-get install -y libgconf2-4 libxtst6 libnss3 libasound2 xvfb dbus-x11 libgtk2.0-common libxss1 curl unzip
RUN npm install -g electron-prebuilt

RUN cd / \
    && curl https://raw.githubusercontent.com/adobe-fonts/source-han-serif/release/OTF/SourceHanSerifSC_EL-M.zip -Lo fonts.zip \
    && unzip fonts.zip \
    && rm fonts.zip \
    && cd /SourceHanSerifSC_EL-M \
    && mv ./* /usr/share/fonts

COPY ./package.json /opt/package.json
RUN npm install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

CMD [ "sh", "/opt/run.sh" ]
