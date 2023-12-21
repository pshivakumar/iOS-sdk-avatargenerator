import SwiftUI

protocol AvatarGeneratorDelegate: AnyObject {
    func didGenerateAvatarImage(_ image: UIImage)
}

final class AvatarUIView: UIView {
    weak var delegate: AvatarGeneratorDelegate?
    private var avatarImageView: UIImageView!

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .red // Set a background color for visibility
        addSubview(avatarImageView)
    }

    private func generateAvatar(backgroundColor: UIColor, shape: String, eyeColor: UIColor) -> UIImage {
        print("Generating Avatar with backgroundColor: \(backgroundColor), shape: \(shape), eyeColor: \(eyeColor)")

        // Create a SwiftUI view representing the avatar
        let avatarView = AvatarView(
            backgroundColor: Color(backgroundColor),
            shape: Image(systemName: shape).foregroundColor(Color(eyeColor))
                .background(Color.red)
        )

        // Use UIViewRepresentable to convert SwiftUI view to UIView
        let uiView = UIHostingController(rootView: avatarView).view!

        // Render the UIView into an image
        let renderer = UIGraphicsImageRenderer(bounds: uiView.bounds)
        let avatarImage = renderer.image { rendererContext in
            uiView.layer.render(in: rendererContext.cgContext)
        }

        delegate?.didGenerateAvatarImage(avatarImage)

        print("Avatar generated successfully")

        return avatarImage
    }


    func updateAvatar(backgroundColor: UIColor, shape: String, eyeColor: UIColor) {
        print("Updating Avatar with backgroundColor: \(backgroundColor), shape: \(shape), eyeColor: \(eyeColor)")

        let avatarImage = generateAvatar(
            backgroundColor: backgroundColor,
            shape: shape,
            eyeColor: eyeColor
        )

        // Assign the generated image to the image view
        avatarImageView.image = avatarImage
        avatarImageView.frame = bounds
    }
}

struct AvatarView<Shape: View>: View {
    var backgroundColor: Color
    var shape: Shape

    var body: some View {
//        ZStack {
//            Circle()
//                .fill(backgroundColor)
//                .frame(width: 150, height: 150)
//
//            shape
//                .font(.system(size: 25))
//                .offset(x: -35, y: -15) // Offset for the left eye
//
//            shape
//                .font(.system(size: 25))
//                .offset(x: 35, y: -15) // Offset for the right eye
//
//            shape
//                .font(.system(size: 25))
//                .offset(x: 0, y: +30) // Offset for the mouth
//        }
        Text("Hello, World!")
            .frame(width: 150, height: 150)
            .background(backgroundColor)
    }
}


struct AvatarGeneratorView: UIViewRepresentable {
    weak var delegate: AvatarGeneratorDelegate?

    @Binding var selectedBackgroundColor: UIColor
    @Binding var selectedShape: String
    @Binding var selectedEyeColor: UIColor

    func makeUIView(context: Context) -> AvatarUIView {
        let avatarView = AvatarUIView()
        avatarView.delegate = context.coordinator
        avatarView.updateAvatar(
            backgroundColor: selectedBackgroundColor,
            shape: selectedShape,
            eyeColor: selectedEyeColor
        )
        return avatarView
    }

    func updateUIView(_ uiView: AvatarUIView, context: Context) {
        uiView.updateAvatar(
            backgroundColor: selectedBackgroundColor,
            shape: selectedShape,
            eyeColor: selectedEyeColor
        )
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, AvatarGeneratorDelegate {
        var parent: AvatarGeneratorView

        init(parent: AvatarGeneratorView) {
            self.parent = parent
        }

        func didGenerateAvatarImage(_ image: UIImage) {
            parent.delegate?.didGenerateAvatarImage(image)
        }
    }
}

class AvatarGeneratorDelegateImpl: AvatarGeneratorDelegate, ObservableObject {
    func didGenerateAvatarImage(_ image: UIImage) {
        // Handle the generated avatar image in the calling app
        print("Generated Avatar Image")
    }
}

struct ContentView: View {
    @StateObject private var avatarDelegate = AvatarGeneratorDelegateImpl()
    @State private var selectedBackgroundColor = UIColor.red
    @State private var selectedShape = "circle"
    @State private var selectedEyeColor = UIColor.black

    var body: some View {
        NavigationView {
            AvatarGeneratorView(
                delegate: avatarDelegate,
                selectedBackgroundColor: $selectedBackgroundColor,
                selectedShape: $selectedShape,
                selectedEyeColor: $selectedEyeColor
            )
            .navigationTitle("Avatar Generator")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewLayout(.fixed(width: 300, height: 300))

            ContentView()
                .previewLayout(.fixed(width: 300, height: 300))
                .environment(\.colorScheme, .dark)

            AvatarGeneratorView(
                delegate: AvatarGeneratorDelegateImpl(),
                selectedBackgroundColor: .constant(UIColor.red),
                selectedShape: .constant("circle"),
                selectedEyeColor: .constant(UIColor.black)
            )
            .frame(width: 200, height: 200)
            .padding(10)
            .background(Color.gray)
            .cornerRadius(10)
            .previewLayout(.fixed(width: 300, height: 300))
            .environment(\.colorScheme, .light)

            AvatarGeneratorView(
                delegate: AvatarGeneratorDelegateImpl(),
                selectedBackgroundColor: .constant(UIColor.red),
                selectedShape: .constant("circle"),
                selectedEyeColor: .constant(UIColor.black)
            )
            .frame(width: 200, height: 200)
            .padding(10)
            .background(Color.gray)
            .cornerRadius(10)
            .previewLayout(.fixed(width: 300, height: 300))
            .environment(\.colorScheme, .dark)
        }
    }
}

