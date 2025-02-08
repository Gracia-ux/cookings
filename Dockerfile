# Utilisation de l'image officielle PHP avec Apache
FROM php:8.1-apache

# Installer les extensions PHP nécessaires (ici pour Symfony)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    zlib1g-dev \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql intl xml zip \
    && a2enmod rewrite

# Installer Composer (gestionnaire de dépendances PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de ton projet dans le conteneur
COPY . .

# Installer les dépendances de Symfony via Composer
RUN composer install --no-dev --optimize-autoloader

# Configurer Apache pour que Symfony fonctionne correctement
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Exposer le port 80 pour l'application web
EXPOSE 80

# Démarrer Apache dans le conteneur
CMD ["apache2-foreground"]
