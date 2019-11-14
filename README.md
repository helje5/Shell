# Shell

![Swift5](https://img.shields.io/badge/swift-5-blue.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)

Module exposing Unix command line tools as Swift 5 @dynamicCallable functions

A few words of warning:
This is intended as a demo. 
It should work just fine, but in the name of error handling and proper Swift
beauty, 
you might want to approach forking processes differently 🤓
(BTW: PRs are welcome!)

Part of this blog post:
[@dynamicCallable: Unix Tools as Swift Functions](http://www.alwaysrightinstitute.com/swift-dynamic-callable/).

## Sample tool

The regular Swift Package Manager setup process:

```shell
mkdir ShellConsumerTest && cd ShellConsumerTest
swift package init --type executable
```

Sample `main.swift`:
```swift
import Shell

print(shell.host("zeezide.de"))
```

Sample `Package.swift`:
```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ShellConsumerTest",
    dependencies: [
        .package(url: "https://github.com/AlwaysRightInstitute/Shell.git",
                 from: "0.1.0"),
    ],
    targets: [
        .target(name: "ShellConsumerTest", dependencies: [ "Shell" ]),
    ]
)
```
Remember to add the dependency in two places. WET is best!

> `swift run` and `swift test` patch the `$PATH` to just `/usr/bin`. You
> may want to run the binary directly to make lookup work properly.

For this to work, you need to have Swift 5+ installed.

## Links

- [SE-0195 Dynamic Member Lookup](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md)
- [SE-0216 Dynamic Callable](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md)
- Python [sh module](https://amoffat.github.io/sh/)


## Who

Brought to you by
[ZeeZide](http://zeezide.de).
We like
[feedback](https://twitter.com/ar_institute),
GitHub stars,
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.
