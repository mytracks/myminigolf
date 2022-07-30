# Install bundler

_bundler_ has to be installed locally on your Mac.

```sh
gem install bundler
```

# Install fastlane

Next, change to the root folder of this project und run the following command to install _fastlane_:

```sh
bundle install
```

# Install SnapshotHelper and Snapfile

The following command generates the initial _Snapfile_ and the _SnapshotHelper_. The command only has to be executed once.

```sh
fastlane snapshot init
```

# Generate screenshots

To generate the screenshots change to the root folder of this project and run the following command:

```sh
fastlane snapshot
```

