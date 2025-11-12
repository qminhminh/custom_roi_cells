# Guide to Publish Package to pub.dev

## Step 1: Preparation

1. Ensure Flutter SDK is installed
2. Log in to pub.dev with Google account
3. Check all required files:
   - `pubspec.yaml` - updated description and version
   - `README.md` - has complete documentation
   - `CHANGELOG.md` - has changelog
   - `LICENSE` - has license (MIT)
   - `example/` - has example app

## Step 2: Code Check

Run the following commands to check:

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Run example app
cd example
flutter run
```

## Step 3: Update Information in pubspec.yaml

Ensure the following information is correct:
- `name`: Package name (must be unique on pub.dev)
- `description`: Brief description (maximum 60 characters)
- `version`: Current version
- `homepage`: GitHub repository URL
- `repository`: GitHub repository URL
- `issue_tracker`: GitHub issues URL

**Note:** Update GitHub URLs in `pubspec.yaml` with your actual repository.

## Step 4: Create pub.dev Account

1. Visit https://pub.dev
2. Log in with Google account
3. Go to "Publisher" section to create publisher (if not already created)

## Step 5: Publish Package

```bash
# Check package before publishing
flutter pub publish --dry-run

# Publish package
flutter pub publish
```

## Step 6: After Publishing

1. Check package on pub.dev
2. Update README if needed
3. Create tags on GitHub:
   ```bash
   git tag v0.2.0
   git push origin v0.2.0
   ```

## Important Notes

- **Version**: Must increment version for each publish
- **Changelog**: Always update CHANGELOG.md when there are changes
- **Tests**: Ensure all tests pass
- **Documentation**: Ensure README.md is complete and clear
- **License**: Must have license file

## Update Package After Publishing

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Commit and push code
4. Run `flutter pub publish`
5. Create new tag on GitHub

## Troubleshooting

- **Error "Package already exists"**: Package name is already in use, need to change name
- **Error "Invalid version"**: Version format is incorrect (must be x.y.z)
- **Error "Missing files"**: Missing required files (README, LICENSE, etc.)
