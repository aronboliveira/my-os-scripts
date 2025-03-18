Get-ChildItem -Path "C:\path\to\dir" -File | Where-Object {
    ($_ | Get-Content -Raw) -match '^\s*$'
} | Select-Object FullName