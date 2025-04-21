#!/bin/bash

# 環境変数がセットされていない場合のデフォルト値
SERVER_NAME=${SERVER_NAME:-localhost}

# 設定ファイルパス
CADDYFILE="/etc/caddy/Caddyfile"

# Caddyfileのサーバー名を環境変数の値に置き換える
sed -i "s/localhost/$SERVER_NAME/g" $CADDYFILE

# FrankenPHPを起動
exec frankenphp run --config $CADDYFILE 