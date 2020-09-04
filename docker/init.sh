#!/bin/bash
sed -i "s/REPLACEME/${SECRET_KEY_BASE}/g" /etc/nginx/sites-enabled/default
