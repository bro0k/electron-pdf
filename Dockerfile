FROM node:slim

RUN apt-get update

# Install dependencies for running electron
RUN apt-get install -y \
  xvfb \
  x11-xkb-utils \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  x11-apps \
  clang \
  libdbus-1-dev \
  libgtk2.0-dev \
  libnotify-dev \
  libgnome-keyring-dev \
  libgconf2-dev \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libxtst-dev \
  libxss1 \
  libnss3-dev \
  gcc-multilib \
  g++-multilib \
  ttf-liberation

WORKDIR /opt

COPY ./fonts/* /usr/share/fonts

COPY ./package.json /opt/package.json
RUN yarn install

COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/

EXPOSE 3000
ENV PORT 3000

RUN export DISPLAY=':9.0' && Xvfb :9 -screen 0 1280x2000x32 > /dev/null 2>&1 &

CMD [ "yarn", "start" ]
