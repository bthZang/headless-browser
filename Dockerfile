FROM node:20.11.1

# Install the latest Chrome dev package and necessary fonts and libraries
RUN apt-get update 
RUN apt -f install -y
RUN apt-get install -y wget
RUN apt-get install -y gnupg 
RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] <https://dl-ssl.google.com/linux/chrome/deb/> stable main" > /etc/apt/sources.list.d/google.list
FROM ros:kinetic-robot-xenial
RUN apt-get update

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    hicolor-icon-theme \
    libcanberra-gtk* \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpangox-1.0-0 \
    libpulse0 \
    libv4l-0 \
    fonts-symbola \
    --no-install-recommends \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome/Downloads && chown -R chrome:chrome /home/chrome

# RUN apt-get -y install google-chrome-stable
RUN rm -rf /var/lib/apt/lists/*
RUN groupadd -r apify && useradd -rm -g apify -G audio,video apify

# Determine the path of the installed Google Chrome
RUN which google-chrome-stable || true

# Switch to the non-root user
USER apify

# Set the working directory
WORKDIR /home/apify

# Copy package.json and package-lock.json
COPY --chown=apify:apify package*.json ./

# Install Puppeteer without downloading bundled Chromium
RUN npm install puppeteer --no-save

# Copy your Puppeteer script into the Docker image
COPY --chown=apify:apify . .

# Update the PUPPETEER_EXECUTABLE_PATH to the correct Chrome path (placeholder, update based on the output of `which google-chrome-stable`)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true 
ENV   PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Set the command to run your Puppeteer script
CMD ["node", "puppeteer-script.js"]