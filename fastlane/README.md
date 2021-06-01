fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### say_hi
```
fastlane say_hi
```
say hello for testing
### build_for_testing
```
fastlane build_for_testing
```
installing dependencies, building using scan
### run_tests
```
fastlane run_tests
```
running tests on compiled application
### build_and_test
```
fastlane build_and_test
```
running building and testing
### discord_success
```
fastlane discord_success
```
successful test notification
### discord_failure
```
fastlane discord_failure
```
failure test notification

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
