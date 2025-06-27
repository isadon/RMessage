# Changelog
All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

DateTime Format (UTC): `yyyy-mm-ddThh:mm:ssZ`

##### Allowed Subsections:
- Added for new features.
- Changed for changes in existing functionality.
- Deprecated for soon-to-be removed features.
- Removed for now removed features.
- Fixed for any bug fixes.
- Security in case of vulnerabilities.

## [Unreleased]
### Added
- General:
  - Migrate code to support to Swift 5.0.
  - Refactor to use a single config
- Build: Add support for SwiftPM.
- Demo App: Update html embed example to include css style for tags.

### Fixed
- Demo App: Fix tests not working due to changes in iOS 13.0.

### Changed
- General:
  - Code cleanup and simplification of nib bundle loading.
  - Use custom textViews that don't allow selection for title and body labels so
    as to support embedding html formatted text.

### Removed
- Build:
  - Remove Mac Catalyst Support.
  - Remove support for Carthage.
  - Remove use of SwiftHEXColors Dependency.
