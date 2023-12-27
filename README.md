# AvatarGenerator SDK for iOS

The AvatarGenerator SDK for iOS is a versatile library that allows developers to easily integrate customizable avatar profile pictures into their iOS applications.

## Features

- **Customization:** Choose from a variety of options, including eye/nose shape, skin color, and more, using the convenient selection form.

- **Easy Integration:** Quickly integrate avatar generation into your app with minimal code by utilizing the **'AvatarGeneratorView'** in SwiftUI.

- **UIKit and SwiftUI Support:** Compatible with both UIKit and SwiftUI, providing flexibility for different app architectures.

- **Delegate Handling:** Implement the AvatarGeneratorDelegate protocol for custom handling of the generated avatar image. This allows you to perform specific actions, such as saving the image to the photo library or sharing it.

## Installation

### Swift Package Manager

You can use Swift Package Manager to integrate AvatarGenerator into your Xcode project:

1. In your Xcode project, go to File -> Swift Packages -> Add Package Dependency
2. Enter the following URL: https://github.com/pshivakumar/iOS-sdk-avatargenerator.git
3. Follow the prompts to complete the integration.

## Usage

1. Import the AvatarGenerator module:

```swift
    import AvatarGenerator
```
2. Add the AvatarGeneratorView to your SwiftUI UI:

```swift
// Example implementation
@State private var isShowingForm = false

var body: some View {
    VStack {
        AvatarGeneratorView(
            delegate: yourAvatarGeneratorDelegate,
            selectedBackgroundColor: $yourBackgroundColor,
            selectedEyeShape: $yourEyeShape,
            selectedShapeColor: $yourShapeColor,
            selectedMouthShape: $yourMouthShape
        )
        .frame(width: 200, height: 200)

        Button("Your Button Name") {
            isShowingForm.toggle()
        }
        .padding()
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .sheet(isPresented: $isShowingForm) {
            SelectionFormView(
                selectedBackgroundColor: $yourBackgroundColor,
                selectedEyeShape: $yourEyeShape,
                selectedMouthShape: $yourMouthShape,
                selectedShapeColor: $yourShapeColor
            )
        }
    }
}

```
3. (Optional) Implement AvatarGeneratorDelegate for custom handling:

    If you want to perform specific actions after generating the avatar image, implement the AvatarGeneratorDelegate protocol in your SwiftUI view or ViewModel.
```swift
class YourViewModel: AvatarGeneratorDelegate {
    func didGenerateAvatarImage(_ image: UIImage) {
        // Handle the generated avatar image
        // Example: Save it to the photo library, share it, etc.
    }
}
```
4. Check the Sample App:

    For detailed implementation check the sample app included in the project

### License
This repository is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the content, provided you include the appropriate attribution and follow the terms of the license.