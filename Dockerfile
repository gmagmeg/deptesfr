FROM dunglas/frankenphp:latest

WORKDIR /app

# システム依存関係のインストール
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# PHPの拡張機能のインストール
RUN install-php-extensions \
    pdo_mysql \
    zip \
    opcache \
    pcntl \
    bcmath

# プロジェクトファイルのコピー
COPY . .

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 依存関係のインストール
RUN composer install --no-interaction --optimize-autoloader --no-dev

# .envファイルのコピー
COPY .env.example .env

# アプリケーションキーの生成
RUN php artisan key:generate --force

# パーミッションの設定
RUN chown -R www-data:www-data \
    /app/storage \
    /app/bootstrap/cache

# ポートの公開
EXPOSE 80 443

# コンテナ起動時のコマンド
CMD ["frankenphp"]
