# memcached-plesk
Memcached Installation Script for Plesk PHP Handlers
# Memcached Installation Script for Plesk PHP Handlers

This script automates the installation of the Memcached PHP extension for all PHP versions available in Plesk PHP Handlers. It provides an easy and convenient way to install Memcached without manually configuring each PHP version.

## Features

- Installs Memcached PHP extension for all PHP versions in Plesk PHP Handlers.
- Creates backups of PHP configuration files before making any changes.
- Prompts for confirmation before performing each action.
- Supports both Red Hat and Debian-based operating systems.
- Restarts the PHP-FPM service and Apache server when necessary.

## Usage

1. Clone or download this repository to your server.
2. Open a terminal and navigate to the repository directory.
3. Make the script executable: `chmod +x install_memcached.sh`.
4. Execute the script: `./install_memcached.sh`.
5. Follow the prompts to confirm the installation and perform the necessary actions.

## Requirements

- Plesk control panel installed on your server.
- Root access or sufficient privileges to install packages and restart services.

## Notes

- The script creates a backup directory in the root user's home directory (`/root/memcached_backup/`) to store backups of PHP and Apache configuration files. You can change this directory if needed by modifying the `backup_dir` variable in the script.
- The script installs the necessary dependencies based on the operating system. It requires either `yum` (for Red Hat) or `apt-get` (for Debian) package managers to be available.
- This script assumes the default installation paths for Plesk PHP versions. If your setup differs, you may need to modify the script accordingly.

## License

This script is released under the [MIT License](LICENSE).

## Author

- George Chatzitaskos - [SmartBytes Dev](https://smartbytes.gr)

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

