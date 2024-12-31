#!/bin/bash

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "\nDocker is not installed on your system."
        read -p "Do you want to install Docker? (yes/no): " install_choice
        case "$install_choice" in
            yes|Yes|y|Y)
                detect_os ;;
            no|No|n|N)
                echo "Docker is required to run this script. Exiting..."
                exit 1 ;;
            *)
                echo "Invalid choice. Exiting..."
                exit 1 ;;
        esac
    else
        echo "Docker is already installed."
    fi
}



# Function to detect the operating system
detect_os() {
    if [ -f /etc/os-release ]; then
        distro=`grep '^ID=' /etc/os-release | cut -d= -f2 | awk -F'"' '{print$2}'`
    else
        echo "Unable to detect the operating system. Exiting..."
        exit 1
    fi

    case "$distro" in
        ubuntu|debian)
            install_docker_debian ;;
        centos|rhel)
            install_docker_rhel ;;
        raspbian)
            install_docker_raspberry ;;
        sles)
            install_docker_sles ;;
        *)
            echo "Unsupported distribution: $distro"
            echo "Attempting to install Docker using generic binaries..."
            install_docker_binaries ;;
    esac
}


# Function to install Docker on Debian-based distributions (Ubuntu, Debian)
install_docker_debian() {
    echo "Detected OS: $distro"
    echo "Installing Docker on $distro..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/$distro/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$distro $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    post_install_steps
}

# Function to install Docker on RHEL-based distributions (CentOS, RHEL)
install_docker_rhel() {
    echo "Detected OS: $distro"
    echo "Installing Docker on $distro..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
    post_install_steps
}

# Function to install Docker on Raspberry Pi OS
install_docker_raspberry() {
    echo "Detected OS: Raspberry Pi OS"
    echo "Installing Docker on Raspberry Pi OS..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    post_install_steps
}

# Function to install Docker on SUSE Linux Enterprise Server (SLES)
install_docker_sles() {
    echo "Detected OS: SLES"
    echo "Installing Docker on SLES..."
    sudo zypper refresh
    sudo zypper install -y docker
    sudo systemctl enable docker
    sudo systemctl start docker
    post_install_steps
}

# Function to install Docker using generic binaries
install_docker_binaries() {
    echo "Installing Docker using binaries..."
    curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.11.tgz -o docker.tgz
    tar xzvf docker.tgz
    sudo mv docker/* /usr/bin/
    sudo chmod +x /usr/bin/docker*
    sudo dockerd &> /dev/null &
    post_install_steps
}

# Function to handle post-installation steps
post_install_steps() {
    # Start Docker service
    if command -v systemctl &> /dev/null; then
        sudo systemctl start docker
        sudo systemctl enable docker
    fi

    # Verify Docker installation
    if command -v docker &> /dev/null; then
        echo "Docker installed successfully."
        echo "Adding current user to Docker group..."
        sudo usermod -aG docker $USER
        echo "You might need to log out and log back in for Docker group permissions to take effect."
    else
        echo "Failed to install Docker. Please try installing manually."
        exit 1
    fi
}




# Function to display the menu
display_menu() {
    echo -e "\n--- Docker Container Management Menu ---"
    echo "1. Launch a container"
    echo "2. Pull an image"
    echo "3. Stop a container"
    echo "4. List all images"
    echo "5. List all running containers"
    echo "6. List all containers (running and stopped)"
    echo "7. Remove a container"
    echo "8. Remove an image"
    echo "9. Stop all containers"
    echo "10. Remove all containers"
    echo "11. Remove all images"
    echo "12. Create a Dockerfile"
    echo "13. Build an image from Dockerfile"
    echo "14. Attach to a running container"
    echo "15. Create a network"
    echo "16. List all networks"
    echo "17. Inspect a network"
    echo "18. Remove a network"
    echo "19. Launch a container using a network"
    echo "20. Exit"
    echo -n "Enter your choice: "
}

# Function to validate container or image names
validate_name() {
    if [[ -z "$1" ]]; then
        echo "Error: Name cannot be empty."
        return 1
    fi
    return 0
}

# Function to validate Docker command success
validate_command() {
    if [[ $? -ne 0 ]]; then
        echo "Error: The last command failed. Please check the Docker logs for details."
        return 1
    fi
    return 0
}

# Function to confirm destructive actions
confirm_action() {
    read -p "Are you sure you want to proceed? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Action canceled."
        return 1
    fi
    return 0
}


# Function to launch a container
launch_container() {
    echo -e "\nAvailable images on your system:"
    docker images | awk '{print $1 "   :   " $2}'

    read -p "Enter the name for the container: " container_name
    read -p "Enter the image name (e.g., ubuntu:latest or select from the list above): " image_name
    
    if [[ -z "$image_name" ]]; then
        echo "Image name cannot be empty. Please try again."
        return
    fi

    docker run -dit --name "$container_name" "$image_name" && \
    echo "Container '$container_name' launched successfully using image '$image_name'." || \
    echo "Failed to launch container '$container_name' using image '$image_name'."
}


# Function to pull an image
pull_image() {
    read -p "Enter the image name (e.g., ubuntu:latest): " image_name
    validate_name "$image_name" || return
    docker pull "$image_name"
    validate_command && echo "Image '$image_name' pulled successfully."
}

# Function to stop a container
stop_container() {
    read -p "Enter the name of the container to stop: " container_name
    validate_name "$container_name" || return
    docker stop "$container_name" && \
    echo "Container '$container_name' stopped successfully." || \
    echo "Failed to stop container '$container_name'. Ensure it exists and is running."
}

# Function to list all images
list_images() {
    echo -e "\nListing all images:"
    docker images
}

# Function to list all running containers
list_running_containers() {
    echo -e "\nListing all running containers:"
    docker ps
}

# Function to list all containers
list_all_containers() {
    echo -e "\nListing all containers (running and stopped):"
    docker ps -a
}

# Function to remove a container
remove_container() {
    read -p "Enter the name of the container to remove: " container_name
    validate_name "$container_name" || return
    docker rm "$container_name" && \
    echo "Container '$container_name' removed successfully." || \
    echo "Failed to remove container '$container_name'. Ensure it exists and is stopped."
}

# Function to remove an image
remove_image() {
    read -p "Enter the name of the image to remove: " image_name
    validate_name "$image_name" || return
    docker rmi "$image_name" && \
    echo "Image '$image_name' removed successfully." || \
    echo "Failed to remove image '$image_name'. Ensure it is not being used by a container."
}

# Function to stop all containers
stop_all_containers() {
    confirm_action || return
    docker stop $(docker ps -q) && \
    echo "All running containers stopped successfully." || \
    echo "No running containers to stop."
}

# Function to remove all containers
remove_all_containers() {
    confirm_action || return
    docker rm -f $(docker ps -aq) && \
    echo "All containers removed successfully." || \
    echo "No containers to remove."
}

# Function to remove all images
remove_all_images() {
    confirm_action || return
    docker rmi -f $(docker images -q) && \
    echo "All images removed successfully." || \
    echo "No images to remove."
}

# Function to create a Dockerfile
create_dockerfile() {
    read -p "Enter the base image (e.g., ubuntu:latest): " base_image
    validate_name "$base_image" || return
    echo "Enter additional Dockerfile instructions (end with an empty line):"
    instructions=""
    while true; do
        read line
        if [[ -z "$line" ]]; then
            break
        fi
        instructions+="$line"$'\n'
    done

    cat > Dockerfile <<EOF
FROM $base_image
$instructions
EOF

    echo "Dockerfile created successfully."
}

# Function to build an image from Dockerfile
build_dockerfile() {
    read -p "Enter the name for the image to build: " image_name
    validate_name "$image_name" || return
    docker build -t "$image_name" . && \
    echo "Image '$image_name' built successfully." || \
    echo "Failed to build image '$image_name'. Check the Dockerfile syntax."
}

# Main script loop
while true; do
    display_menu
    read choice
    case $choice in
        1) launch_container ;;
        2) pull_image ;;
        3) stop_container ;;
        4) list_images ;;
        5) list_running_containers ;;
        6) list_all_containers ;;
        7) remove_container ;;
        8) remove_image ;;
        9) stop_all_containers ;;
        10) remove_all_containers ;;
        11) remove_all_images ;;
        12) create_dockerfile ;;
        13) build_dockerfile ;;
        14) attach_container ;;
        15) create_network ;;
        16) list_networks ;;
        17) inspect_network ;;
        18) remove_network ;;
        19) launch_container_with_network ;;
        20) echo "Exiting..." && exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
