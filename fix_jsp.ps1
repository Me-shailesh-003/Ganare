$files = Get-ChildItem -Path "web" -Filter "*.jsp" -Recurse
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $pattern = 'Connection\s+cn\s*=\s*DriverManager\.getConnection\("jdbc:mysql://localhost:3306/gana_bajao",\s*"shailesh",\s*""\);'
    $replacement = 'String dbUrl = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/gana_bajao"; String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "shailesh"; String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : ""; Connection cn = DriverManager.getConnection(dbUrl, dbUser, dbPass);'
    if ($content -match $pattern) {
        $content = $content -replace $pattern, $replacement
        [System.IO.File]::WriteAllText($file.FullName, $content)
        Write-Host "Replaced in $($file.FullName)"
    }
}
