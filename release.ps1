$addonName = "SmartAssist"
$tocPath = "$addonName\$addonName.toc"

# Lire version
$versionLine = Get-Content $tocPath | Where-Object { $_ -match "^## Version:" }
$version = $versionLine -replace "## Version:\s*", ""
$tag = "v$version"

$zipName = "$addonName.zip"

Write-Host "Version: $version"

# Supprimer ancien zip
if (Test-Path $zipName) {
    Remove-Item $zipName
}

# Créer zip SANS version
Compress-Archive -Path $addonName -DestinationPath $zipName

# Git commit + tag
git add .
git commit -m "Release $tag"
git tag $tag
git push origin main
git push origin $tag

# Créer release avec zip
gh release create $tag $zipName `
    --title "$addonName $tag" `
    --notes "Release $tag"

Write-Host "Release created with $zipName 🚀"