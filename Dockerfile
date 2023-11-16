FROM ubuntu:18.04

RUN apt-get update && \
  apt-get install -y curl && \
# Node v7 doesn't cut it anymore, so lets get 18 (what electron packages)
  curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs \
# Required for a GUI
    xvfb dbus-x11 libgtk-3-common \
# Required by Electron (to run)
    libxss1 libasound2 \
# Required for PDF -> PNG Conversion
    mupdf-tools \
# Used for PDF->PNG splitting by pdf2images-multiple
    poppler-utils && \
# Get rid of files we don't need
  rm -rf /var/lib/apt/lists/* && \
# Get latest npm
  npm install -g npm

# Copy this before user and folder permissions are assigned but as late as possible
# To prevent additional docker layers from needing rebuilt when it changes
WORKDIR /opt
COPY ./run.sh /opt/run.sh
COPY ./lib/ /opt/lib/
COPY ./package.json /opt/package.json
COPY ./fonts/* /usr/share/fonts

RUN \
# sbe is a non-privileged user for running the export server
# (so that there is no attack vector from root escalating out onto the host;
#  this is a docker best practice for running in production)
# Home directory is for the Chrome sandbox
# Hard coded ids of 1500:1500 so we can map the user/group to the production host user/group
groupadd -g 1500 -r sbe && \
useradd -u 1500 --no-log-init -m -r -g sbe -G audio,video sbe && \
mkdir -p /home/sbe/Downloads && \
chown -R sbe:sbe /home/sbe && \
chown -R sbe:sbe /opt && \
chmod -R 755 /opt

# Run as a non-privileged user (inside the container)
USER sbe

ENV NODE_ENV="production"
# Must be after setting the sbe user or electron will choke on file permissions
RUN npm install

CMD [ "sh", "/opt/run.sh" ]
