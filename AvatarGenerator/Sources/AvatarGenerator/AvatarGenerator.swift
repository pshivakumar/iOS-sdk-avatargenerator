import SwiftUI

public protocol AvatarGeneratorDelegate: AnyObject {
    func didGenerateAvatarImage(_ image: UIImage)
}

public final class AvatarUIView: UIView {
    public weak var delegate: AvatarGeneratorDelegate?
    private var avatarImageView: UIImageView!

    public init() {
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

public struct AvatarView<Shape: View>: View {
    var backgroundColor: Color
    var shape: Shape

    public var body: some View {
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


public struct AvatarGeneratorView: UIViewRepresentable {
    public weak var delegate: AvatarGeneratorDelegate?

    @Binding public var selectedBackgroundColor: UIColor
    @Binding public var selectedShape: String
    @Binding public var selectedEyeColor: UIColor
    
    // Make the initializer public
    public init(
        delegate: AvatarGeneratorDelegate?,
        selectedBackgroundColor: Binding<UIColor>,
        selectedShape: Binding<String>,
        selectedEyeColor: Binding<UIColor>
    ) {
        self.delegate = delegate
        self._selectedBackgroundColor = selectedBackgroundColor
        self._selectedShape = selectedShape
        self._selectedEyeColor = selectedEyeColor
    }

    public func makeUIView(context: Context) -> AvatarUIView {
        let avatarView = AvatarUIView()
        avatarView.delegate = context.coordinator
        avatarView.updateAvatar(
            backgroundColor: selectedBackgroundColor,
            shape: selectedShape,
            eyeColor: selectedEyeColor
        )
        return avatarView
    }

    public func updateUIView(_ uiView: AvatarUIView, context: Context) {
        uiView.updateAvatar(
            backgroundColor: selectedBackgroundColor,
            shape: selectedShape,
            eyeColor: selectedEyeColor
        )
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    public class Coordinator: NSObject, AvatarGeneratorDelegate {
        var parent: AvatarGeneratorView

        public init(parent: AvatarGeneratorView) {
            self.parent = parent
        }

        public func didGenerateAvatarImage(_ image: UIImage) {
            parent.delegate?.didGenerateAvatarImage(image)
        }
    }
}

public class AvatarGeneratorDelegateImpl: AvatarGeneratorDelegate, ObservableObject {
    
    public init() {}
    
    public func didGenerateAvatarImage(_ image: UIImage) {
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
            .background(Color.white)
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
            .background(Color.white)
            .cornerRadius(10)
            .previewLayout(.fixed(width: 300, height: 300))
            .environment(\.colorScheme, .dark)
        }
    }
}

