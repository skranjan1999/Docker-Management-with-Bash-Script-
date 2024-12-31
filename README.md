
# Docker Management Automation Script

A comprehensive Bash script to automate Docker installation, management, and container orchestration tasks. This script is designed to simplify Docker-related operations and provide a user-friendly, menu-driven interface for managing containers, images, networks, and more. It also includes functionality to detect the operating system and install Docker if it's not already present.

---

## Features

### Installation
- Automatically detects the operating system (Ubuntu, Debian, CentOS, RHEL, Raspberry Pi OS, SLES, etc.).
- Installs Docker using appropriate methods for the detected OS or generic binaries for unsupported systems.
- Includes post-installation steps to set up Docker services and configure user permissions.

### Docker Management
- **Container Management**:
  - Launch new containers.
  - Stop running containers.
  - Remove containers (individually or all at once).
  - Attach to running containers.
- **Image Management**:
  - Pull images from Docker Hub.
  - List all available images.
  - Remove images (individually or all at once).
- **Network Management**:
  - Create custom networks.
  - List all Docker networks.
  - Inspect specific networks.
  - Remove unused or specific networks.

### Dockerfile and Image Building
- Create custom `Dockerfile`s interactively.
- Build Docker images from `Dockerfile`s with user-defined tags.

### System-Wide Actions
- Stop all running containers.
- Remove all stopped containers.
- Remove all Docker images.

---

## Prerequisites

- A Linux-based operating system (Ubuntu, Debian, CentOS, RHEL, etc.).
- `bash` shell.
- Root or sudo privileges for installing Docker and managing permissions.

---

## Usage

1. Clone or download the script to your local machine.
2. Make the script executable:
   ```bash
   chmod +x docker_manager.sh
