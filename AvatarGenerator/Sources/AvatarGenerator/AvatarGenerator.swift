import SwiftUI

public protocol AvatarGeneratorDelegate: AnyObject {
    func didGenerateAvatarImage(_ image: UIImage)
}

public final class AvatarUIView: UIView {
    public weak var delegate: AvatarGeneratorDelegate?
    private var avatarImageView: UIImageView!

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200)) // Set the size accordingly
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }

    private func setupUI() {
        avatarImageView = UIImageView()
        avatarImageView.backgroundColor = .clear // Set a  different, if required, background color for visibility
        addSubview(avatarImageView)
    }

    private func generateAvatar(backgroundColor: Color, shape: String, eyeColor: Color, mouthShape: String) -> UIImage {
        // Create a SwiftUI view representing the avatar
        let avatarView = AvatarView(selectedBackgroundColor: .constant(backgroundColor), selectedEyeShape: .constant(shape), selectedShapeColor: .constant(eyeColor), selectedMouthShape: .constant(mouthShape))

        let controller = UIHostingController(rootView: avatarView)
        let view = controller.view
        
        let targetSize = CGSize(width: 250, height: 250) // Set your desired size
        
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let avatarImage =  renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        delegate?.didGenerateAvatarImage(avatarImage)

        return avatarImage
    }


    func updateAvatar(backgroundColor: Color, shape: String, eyeColor: Color, mouthShape: String) {
        print("Updating Avatar with backgroundColor: \(backgroundColor), shape: \(shape), eyeColor: \(eyeColor)")

        let avatarImage = generateAvatar(
            backgroundColor: backgroundColor,
            shape: shape,
            eyeColor: eyeColor,
            mouthShape: mouthShape
        )

        // Assign the generated image to the image view
        avatarImageView.image = avatarImage

        // Adjust the content mode to center the image within the avatarImageView
        avatarImageView.contentMode = .center

        // Resize and center the avatarImageView within bounds with padding
        avatarImageView.frame = bounds
    }
}

public struct AvatarGeneratorView: UIViewRepresentable {
    public weak var delegate: AvatarGeneratorDelegate?

    @Binding public var selectedBackgroundColor: Color
    @Binding public var selectedEyeShape: String
    @Binding public var selectedShapeColor: Color
    @Binding public var selectedMouthShape: String
    
    // Make the initializer public
    public init(
        delegate: AvatarGeneratorDelegate?,
        selectedBackgroundColor: Binding<Color>,
        selectedEyeShape: Binding<String>,
        selectedShapeColor: Binding<Color>,
        selectedMouthShape: Binding<String>
    ) {
        self.delegate = delegate
        self._selectedBackgroundColor = selectedBackgroundColor
        self._selectedEyeShape = selectedEyeShape
        self._selectedShapeColor = selectedShapeColor
        self._selectedMouthShape = selectedMouthShape
    }

    public func makeUIView(context: Context) -> AvatarUIView {
        let avatarView = AvatarUIView()
        avatarView.delegate = context.coordinator
        avatarView.updateAvatar(
            backgroundColor: selectedBackgroundColor,
            shape: selectedEyeShape,
            eyeColor: selectedShapeColor, 
            mouthShape: selectedMouthShape
        )
        return avatarView
    }

    public func updateUIView(_ uiView: AvatarUIView, context: Context) {
        uiView.updateAvatar(
            backgroundColor: selectedBackgroundColor,
            shape: selectedEyeShape,
            eyeColor: selectedShapeColor,
            mouthShape: selectedMouthShape
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
    @State private var selectedBackgroundColor = Color.red
    @State private var selectedEyeShape = "circle"
    @State private var selectedShapeColor = Color.black
    @State private var selectedMouthShape = "infinity"
    @State private var isFormShowing = false

    var body: some View {
        VStack {
            NavigationView {
                AvatarGeneratorView(
                    delegate: avatarDelegate,
                    selectedBackgroundColor: $selectedBackgroundColor,
                    selectedEyeShape: $selectedEyeShape,
                    selectedShapeColor: $selectedShapeColor,
                    selectedMouthShape: $selectedMouthShape
                )
                .navigationTitle("Avatar Generator")
            } //: NAVIGATIONVIEW
            
            Button("Show Selection Form") {
                isFormShowing.toggle()
            }
            .padding()
            .sheet(isPresented: $isFormShowing, content: {
                VStack {
                    // 1. Drag Indicator
                    Capsule()
                        .fill(Color.secondary)
                        .opacity(0.6)
                        .frame(width: 40, height: 5)
                        .padding(20)
                    
                    // 2. Selection Form
                    SelectionFormView(
                        selectedBackgroundColor: $selectedBackgroundColor,
                        selectedEyeShape: $selectedEyeShape,
                        selectedMouthShape: $selectedMouthShape,
                        selectedShapeColor: $selectedShapeColor
                    )
                } //: VSTACK
            })
        }
        .padding()
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
                selectedBackgroundColor: .constant(Color.red),
                selectedEyeShape: .constant("circle"),
                selectedShapeColor: .constant(Color.black),
                selectedMouthShape: .constant("infinity")
            )
            .frame(width: 200, height: 200)
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .previewLayout(.fixed(width: 300, height: 300))
            .environment(\.colorScheme, .light)

            AvatarGeneratorView(
                delegate: AvatarGeneratorDelegateImpl(),
                selectedBackgroundColor: .constant(Color.red),
                selectedEyeShape: .constant("circle"),
                selectedShapeColor: .constant(Color.black),
                selectedMouthShape: .constant("infinity")
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

