$ErrorActionPreference = "Stop"

Write-Host "Running flutter analyze..."
flutter analyze

Write-Host "Running flutter test..."
flutter test

Write-Host "Done."
