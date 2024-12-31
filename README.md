
# Docker Management Automation Script

A comprehensive Bash script to automate Docker installation, management, and container orchestration tasks. This script is designed to simplify Docker-related operations and provide a user-friendly, menu-driven interface for managing containers, images, networks, and more. It also includes functionality to detect the operating system and install Docker if it's not already present.

---

## Features

### 1. **Docker Installation and Setup**
- **Auto-detection of Operating System**: The script automatically detects the operating system (Ubuntu, Debian, CentOS, RHEL, Raspberry Pi OS, SLES, etc.) and installs Docker using the appropriate method for each distribution.
- **Docker Installation**: If Docker is not already installed, the script offers to install it, including setting up the Docker service and adding the user to the Docker group for easier usage.
- **Generic Binary Installation**: For unsupported distributions, the script installs Docker using pre-built binaries.

### 2. **Container Management**
- **Launch Containers**: You can launch new containers from any available Docker image, specifying the container name and image.
- **Stop Containers**: Stop running containers by specifying their names.
- **Remove Containers**: Easily remove containers, either individually or all at once.
- **Attach to Running Containers**: Attach to a running container to interact with it.
- **Stop All Containers**: Stop all currently running containers with a single command.
- **Remove All Containers**: Remove all containers, whether running or stopped, with a single command.

### 3. **Image Management**
- **Pull Docker Images**: Pull Docker images from Docker Hub or any other registry.
- **List All Images**: View all Docker images available on your system.
- **Remove Images**: Remove specific images or all unused images from the system.

### 4. **Network Management**
- **Create Networks**: Create custom Docker networks to manage container communication.
- **List Networks**: View all networks available in Docker.
- **Inspect Networks**: Inspect network details to check configurations and connected containers.
- **Remove Networks**: Remove unused or specific Docker networks.

### 5. **Dockerfile and Image Building**
- **Create Dockerfile**: Create a Dockerfile interactively, specifying a base image and additional Dockerfile instructions.
- **Build Docker Image**: Build an image from the created Dockerfile with user-defined tags.

### 6. **Post-Installation Steps**
- **Service Setup**: The script ensures Docker services are started and enabled to run on system boot.
- **User Permissions**: After installation, the script adds the current user to the Docker group for easier usage without needing sudo.

### 7. **Destructive Actions Confirmation**
- **Confirmation for Destructive Actions**: For actions like removing containers or images, the script prompts the user for confirmation to avoid accidental deletions.

---

## User-Friendly Menu
- The script provides a clear, easy-to-use menu system to perform Docker operations.
- Simple menu options to manage containers, images, and networks with step-by-step prompts.

---

## Error Handling
- **Docker Command Validation**: After every Docker command, the script validates if the command was successful and notifies the user of any errors.
- **Input Validation**: Ensures valid input for container names, image names, and other user inputs, providing error messages for empty or invalid entries.

---

## Cross-Platform Support
- **Multi-Platform Compatibility**: The script works across multiple Linux distributions, making it highly versatile for use in different environments.


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
