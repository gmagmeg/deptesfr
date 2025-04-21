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

RUN chmod -R 775 /app/storage /app/bootstrap/cache

# .envファイルのコピー
COPY .env.example .env
COPY ./Caddyfile /etc/caddy/Caddyfile

# アプリケーションキーの生成
RUN php artisan key:generate --force

# パーミッションの設定
RUN chown -R www-data:www-data \
    /app/storage \
    /app/bootstrap/cache

# 環境設定
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV LOG_CHANNEL=stderr

ENV PORT=8080

# ポートの公開
EXPOSE ${PORT}

# コンテナ起動時のコマンド
CMD ["frankenphp", "run",  "--config", "/etc/caddy/Caddyfile"]
