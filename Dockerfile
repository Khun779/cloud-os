# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE desktop, VNC server, noVNC, and NetworkManager (optional)
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tightvncserver x11vnc \
    novnc websockify curl wget \
    dbus-x11 xfonts-base \
    network-manager # Optional, if you need networking

# Create a user (replace 'myuser' with your desired username)
RUN useradd -ms /bin/bash myuser

# Set the USER environment variable
ENV USER=myuser

# Set up VNC server password for the new user
USER myuser
RUN mkdir -p ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Set up the .vnc/xstartup file to start XFCE
RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > /home/myuser/.vnc/xstartup && \
    chmod +x /home/myuser/.vnc/xstartup

# Expose necessary ports for VNC and noVNC
EXPOSE 5901 8080

# Start VNC and noVNC on container startup with logging for debugging
CMD ["sh", "-c", "tightvncserver :1 -geometry 1280x1024 -depth 24 && tail -f ~/.vnc/*.log & websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
