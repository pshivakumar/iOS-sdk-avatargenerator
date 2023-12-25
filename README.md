# AvatarGenerator SDK for iOS

The AvatarGenerator SDK for iOS is a versatile library that allows developers to easily integrate customizable avatar profile pictures into their iOS applications.

## Features

- **Customization:** Choose from a variety of options, including eye shape,nose shape, skin color, and more.
- **Easy Integration:** Quickly integrate avatar generation into your app with minimal code.
- **UIKit and SwiftUI Support:** Compatible with both UIKit and SwiftUI, providing flexibility for different app architectures.

## Installation

### Swift Package Manager

You can use Swift Package Manager to integrate AvatarGenerator into your Xcode project:


        1. In your Xcode project, go to File -> Swift Packages -> Add Package Dependency
        2. Enter the following URL: https://github.com/pshivakumar/iOS-sdk-avatargenerator.git
        3. Follow the prompts to complete the integration.

### Usage

1. Import the AvatarGenerator module:

```swift
    import AvatarGenerator
```
2. Create an instance of AvatarGeneratorView:

```swift
    let avatarView = AvatarGeneratorView()
```
3. Customize the avatar as needed:

```swift
    avatarView.hairColor = .brown
    avatarView.eyeColor = .blue
    avatarView.skinColor = .peach
    avatarView.accessoryColor = .black
```
4. Add the view to your UI:

```swift
// For UIKit
view.addSubview(avatarView)

// For SwiftUI
var body: some View {
        AvatarGeneratorView(delegate: , selectedBackgroundColor: , selectedEyeShape: , selectedShapeColor: , selectedMouthShape: )
        .frame(width: 200, height: 200)
}
```
### License
This repository is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the content, provided you include the appropriate attribution and follow the terms of the license.