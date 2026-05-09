#region Laravel_PHP_Aliases
# ═══════════════════════════════════════════════════════════════════════════

function Invoke-Artmrs   { php artisan migrate:reset }
Set-Alias -Name artmrs -Value Invoke-Artmrs

function Invoke-Artmsd   { php artisan migrate:fresh --seed }
Set-Alias -Name artmsd -Value Invoke-Artmsd

function Invoke-Artmst   { php artisan migrate:status }
Set-Alias -Name artmst -Value Invoke-Artmst

function Invoke-ArtmrsSd {
  php artisan migrate:status
  php artisan migrate:reset
  php artisan migrate:fresh --seed
}
Set-Alias -Name artmrs-sd -Value Invoke-ArtmrsSd

function Invoke-Artcl {
  php artisan permission:cache-reset
  php artisan config:clear
  php artisan cache:clear
  php artisan optimize:clear
  php artisan route:clear
  php artisan view:clear
  php artisan clear-compiled
}
Set-Alias -Name artcl -Value Invoke-Artcl

function Invoke-Artsv { php artisan serve }
Set-Alias -Name artsv -Value Invoke-Artsv

function Invoke-Artclrs {
  Invoke-Artcl
  $cache = @(
    'bootstrap/cache/services.php',
    'bootstrap/cache/packages.php',
    'bootstrap/cache/compiled.php',
    'bootstrap/cache/routes.php'
  )
  foreach ($f in $cache) { Remove-Item $f -ErrorAction SilentlyContinue }
  composer dump-autoload -o
  php artisan migrate:status
  php artisan migrate:reset
  php artisan migrate:fresh --seed
  php artisan route:list --sort=uri
  php artisan serve
}
Set-Alias -Name artclrs -Value Invoke-Artclrs

function Invoke-Artrtl { php artisan route:list --sort=uri }
Set-Alias -Name artrtl -Value Invoke-Artrtl

function Remove-LaravelCache {
  $cache = @(
    'bootstrap/cache/services.php',
    'bootstrap/cache/packages.php',
    'bootstrap/cache/compiled.php',
    'bootstrap/cache/routes.php'
  )
  foreach ($f in $cache) { Remove-Item $f -ErrorAction SilentlyContinue }
}
Set-Alias -Name laravel-rm-cache -Value Remove-LaravelCache

function Invoke-Compdp { composer dump-autoload -o }
Set-Alias -Name compdp -Value Invoke-Compdp

function Invoke-Mysqlr { mysql -u root -p }
Set-Alias -Name mysqlr -Value Invoke-Mysqlr

#endregion Laravel_PHP_Aliases

# ═══════════════════════════════════════════════════════════════════════════
