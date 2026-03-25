fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build

```sh
[bundle exec] fastlane ios build
```

Build Flutter release IPA

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload to TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and submit to App Store for review

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Build and upload to App Store Connect (no review submission)

### ios beta_only

```sh
[bundle exec] fastlane ios beta_only
```

Upload existing IPA to TestFlight (no rebuild)

### ios upload_only

```sh
[bundle exec] fastlane ios upload_only
```

Upload existing IPA to App Store Connect (no rebuild, no review)

### ios release_only

```sh
[bundle exec] fastlane ios release_only
```

Upload existing IPA and submit for review (no rebuild)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
