#!/bin/sh

# allow git operations
git config --global --add safe.directory /var/www/html

# re-link public/storage to storage
php artisan storage:link
