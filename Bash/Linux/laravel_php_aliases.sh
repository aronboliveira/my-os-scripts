  #region Laravel_PHP_Aliases
    alias artmrs='php artisan migrate:reset'
    alias artmsd='php artisan migrate:fresh --seed'
    alias artmst='php artisan migrate:status'
    alias artmrs-sd='php artisan migrate:status && php artisan migrate:reset && php artisan migrate:fresh --seed'
    alias artcl='php artisan permission:cache-reset && php artisan config:clear && php artisan cache:clear && php artisan optimize:clear && php artisan route:clear && php artisan view:clear && php artisan clear-compiled'
    alias artsv='php artisan serve'
    alias artclrs='
php artisan permission:cache-reset; \
php artisan config:clear; \
php artisan cache:clear; \
php artisan optimize:clear; \
php artisan route:clear; \
php artisan view:clear; \
php artisan clear-compiled; \
rm -f bootstrap/cache/services.php bootstrap/cache/packages.php bootstrap/cache/compiled.php bootstrap/cache/routes.php; \
composer dump-autoload -o; \
php artisan migrate:status; \
php artisan migrate:reset; \
php artisan migrate:fresh --seed; \
php artisan route:list --sort=uri; \
php artisan serve
'
    alias artrtl='php artisan route:list --sort=uri'
    alias laravel-rm-cache='rm -f bootstrap/cache/services.php && rm -f bootstrap/cache/packages.php && rm -f bootstrap/cache/compiled.php && rm -f bootstrap/cache/routes.php'
    alias compdp='composer dump-autoload -o'
    alias mysqlr='mysql -u root -p'
#endregion Laravel_PHP_Aliases

