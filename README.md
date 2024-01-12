# Laravel Local Enviornment Setup Script
Automate the setup of a Laravel environment on your Local Server with this script. It streamlines the installation of essential components, including Nginx, PHP, MySQL, Composer, and Laravel. The script intelligently checks your system for required software and installs them if missing. Save time and effort in setting up your Laravel Environment with this efficient and automated script.


## Prerequisites
Before running the script, ensure the following prerequisites are met:

- A server running Ubuntu.
- Git installed on the server.
- Internet connectivity on the server for package installations.


## Usage

### 1. Clone Repository:
Clone the repository to your home directory:

```bash
    git clone https://github.com/riyadrb/laravel-local-with-nginx-mysql.git
```

### 2. Run the Setup Script:

```bash
    ./setup.sh
```
### 3. Follow On-Screen Instructions:

The script will prompt you for information such as the PHP VERSION, MySQL Username, MySQL  Password. Enter the required information as prompted.


### 4. Automated Setup:

The script will automatically:

- Install Nginx.
- Set up MySQL with a secure root password.
- Install Composer globally.
- Install Laravel globally.
- Start the Nginx service.


### Notes:

- This script is designed for Ubuntu-based servers.
- Ensure that you have the necessary permissions to execute the script.
- It's recommended to review the script before execution to understand the steps it will perform.

### Troubleshooting:

If any issues occur during the setup, check the script logs for more details. Feel free to open an issue on the repository for assistance.


### License:

This project is licensed under the [MIT License](https://opensource.org/license/mit/). Feel free to customize and use it according to your needs.


#### Feel free to contribute to the improvement of this script or report any issues. Happy coding!

