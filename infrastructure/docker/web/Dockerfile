# Use the official PHP 8.3 Apache image
FROM php:8.3-apache

# Enable necessary Apache modules
RUN a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the virtual host configuration file to Apache
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

# Set working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80
