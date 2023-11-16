FROM buildpack-deps:jessie

WORKDIR /opt

RUN rm /etc/apt/sources.list
RUN echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/jessie.list
RUN echo "deb http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list.d/jessie.list

RUN apt-get install -y curl && \
# Node v7 doesn't cut it anymore, so lets get 18 (what electron packages)
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get install -y nodejs \
# Required for a GUI
  libgtkextra-dev libgconf2-dev libnss3 libasound2 libxtst-dev libxss1 libx11-xcb1 xvfb && \
# Get rid of files we don't need
  rm -rf /var/lib/apt/lists/*

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/
COPY ./package.json /opt/package.json
COPY ./fonts/* /usr/share/fonts

RUN npm install

CMD [ "sh", "/opt/run.sh" ]
