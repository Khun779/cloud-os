# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE desktop, VNC server, and noVNC
RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tightvncserver x11vnc \
    novnc websockify curl wget \
    dbus-x11 xfonts-base

# Set up VNC server password
RUN mkdir -p ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Expose necessary ports for VNC and noVNC
EXPOSE 5901 8080

# Start VNC and noVNC on container startup
CMD ["sh", "-c", "tightvncserver :1 && websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
