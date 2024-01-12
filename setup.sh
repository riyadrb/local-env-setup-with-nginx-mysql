#!/bin/bash

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

read -p "PHP VERSION? e.g:7.4: " PHP_VERSION
read -p "MySQL Username: " DB_USERNAME
read -s -p "MySQL Password: " DB_PASSWORD



required_commands=("git" "curl" "unzip" "expect")
for cmd in "${required_commands[@]}"; 
do 
    if ! command_exists "$cmd"; then
        echo "$cmd is Not Installed!"
        sudo apt install "$cmd" -y
    fi
done





# Installing Nginx
if ! command_exists nginx; then
    echo "Nginx Installing"
    sudo apt update
    sudo apt install nginx -y
fi





function install_php_libraries() {
    PHP_VERSION=$1
    sudo apt install -y \
    php"${PHP_VERSION}"-fpm \
    php"${PHP_VERSION}"-mysql \
    php"${PHP_VERSION}"-zip \
    php"${PHP_VERSION}"-curl \
    php"${PHP_VERSION}"-gd \
    php"${PHP_VERSION}"-intl \
    php"${PHP_VERSION}"-imagick \
    php"${PHP_VERSION}"-imap \
    php"${PHP_VERSION}"-memcache \
    php"${PHP_VERSION}"-pspell \
    php"${PHP_VERSION}"-sqlite3 \
    php"${PHP_VERSION}"-tidy \
    php"${PHP_VERSION}"-xml \
    php"${PHP_VERSION}"-xmlrpc \
    php"${PHP_VERSION}"-xsl \
    php"${PHP_VERSION}"-mbstring \
    php"${PHP_VERSION}"-gettext \
    php"${PHP_VERSION}"-dom     

    if [[ $? == 0 ]]; then
        echo "PHP ${PHP_VERSION} and required libraries have been successfully installed."
    else
        echo "Failed to install PHP ${PHP_VERSION} libraries. Please check logs for more details."
    fi
}




# Switching php version
function switch_php_version() {
    if [[ "$1" == "7" ]]; then
        sudo update-alternatives --set php /usr/bin/php"${PHP_VERSION}"
    elif [[ "$1" == "8" ]]; then
        sudo update-alternatives --set php /usr/bin/php"${PHP_VERSION}"
    else
        echo "Unsupported PHP Version."
    fi
}




# Detecting php version according to user input
function requested_php_version() {
    echo "Detected PHP Version: php${PHP_VERSION}"
        # Checking if the Detected PHP Version is below 7.4 and setting it to 7.4
        if [[ "$(echo -e "7.4\n${PHP_VERSION}" | sort -V | head -n1)" != "7.4" ]]; then
            PHP_VERSION="7.4"
        elif [[ "$PHP_VERSION" == "8.0" ]]; then
            PHP_VERSION="8.1"
        fi
        echo "Adjusted PHP Version:php${PHP_VERSION}"

        if [[ "$PHP_VERSION" != "null" ]]; then
            # Check for supported PHP versions
            if [[ "$PHP_VERSION" == "7.4" ]]; then
                if ! command_exists "php${PHP_VERSION}"; then
                    sudo add-apt-repository ppa:ondrej/php -y   #Added Ondrej repo as ubuntu 22.04's default does not have php7.4
                    sudo apt update
                    echo "PHP $PHP_VERSION is not installed. Installing..."
                    sudo apt install "php${PHP_VERSION}" "php${PHP_VERSION}"-fpm -y  # It will avoid installing default apache2 installation as i use nginx.
                fi
                install_php_libraries "$PHP_VERSION"
                # switch_php_version "$PHP_MAJOR_VERSION"
            elif [[ "$PHP_VERSION" == "8.1" ]]; then
                if ! command_exists "php${PHP_VERSION}"; then
                    echo "PHP $PHP_VERSION is not installed. Installing..."
                    sudo apt install "php${PHP_VERSION}" "php${PHP_VERSION}"-fpm -y
                fi
                install_php_libraries "$PHP_VERSION"
                # switch_php_version "$PHP_MAJOR_VERSION"
            fi
        fi
}
requested_php_version



# Installing composer and laravel
function install_laravel() {
    if ! command_exists composer; then
        echo "Installing composer..."
        sudo apt install php-cli php-mbstring
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
        if ! command_exists composer; then
            echo "ERROR: Composer installation failed" >&2
            exit 1
        fi
        echo "Composer has been installed successfully."
    else
        echo "Composer is already installed."
    fi

    if ! command_exists laravel; then
        composer global require "laravel/installer"
    fi

    if [[ $? == 0 ]]; then
        echo "Laravel has been installed globally."
    else
        echo "Failed to install Laravel globally. Please check logs for more details."
    fi
}
install_laravel




# Check if MySQL is installed
if ! command_exists mysql; then
    echo "MySQL is not installed"
    sudo apt install mysql-server-8.0 -y
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWORD';"
    sudo systemctl restart mysql.service
fi

# Verify MySQL access
mysql -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "SELECT 1;"  # This line will authenticate and check if MySQL is accessible or not
# # Check the exit status of the above command to ensure successful authentication
# if [[ $? == 0 ]]; then
#     echo "MySQL setup successful. Proceeding with database operations..."
#     mysql -u "$DB_USERNAME" -p"$DB_PASSWORD" -e"CREATE DATABASE IF NOT EXISTS $PROJECT_NAME;" || { echo "Faild to Create Mysql Database. Exiting."; exit 1; }
# else
#     echo "Failed to authenticate with MySQL. Exiting."
#     exit 1
# fi



