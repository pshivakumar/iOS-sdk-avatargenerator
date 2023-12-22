import SwiftUI
import UIKit

// TODO: - Remove once the issue with Color+Extension file is resolved

extension Color {
    init?(colorString: String) {
        switch colorString.lowercased() {
        case "red": self = .red
        case "green": self = .green
        case "blue": self = .blue
        case "purple": self = .purple
        case "orange": self = .orange
        case "black": self = .black
        case "gray": self = .gray
        default: return nil
        }
    }
} // TODO ENDS

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
        avatarImageView.backgroundColor = .gray // Set a background color for visibility
        addSubview(avatarImageView)
    }

    private func generateAvatar(backgroundColor: Color, shape: String, eyeColor: Color) -> UIImage {
        // Create a SwiftUI view representing the avatar
        let avatarView = AvatarView(selectedBackgroundColor: .constant(backgroundColor), selectedShape: .constant(shape), selectedEyeColor: .constant(eyeColor))

        let controller = UIHostingController(rootView: avatarView)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let avatarImage =  renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        delegate?.didGenerateAvatarImage(avatarImage)

        print("Avatar generated successfully")
        print("AvatarUIView bounds: \(bounds)")
        print("avatarImageView frame: \(avatarImageView.frame)")

//        return UIImage(systemName: "circle.fill")!
        return avatarImage
    }


    func updateAvatar(backgroundColor: Color, shape: String, eyeColor: Color) {
        print("Updating Avatar with backgroundColor: \(backgroundColor), shape: \(shape), eyeColor: \(eyeColor)")

        let avatarImage = generateAvatar(
            backgroundColor: backgroundColor,
            shape: shape,
            eyeColor: eyeColor
        )

        // Assign the generated image to the image view
        avatarImageView.image = avatarImage

        // Adjust the content mode to center the image within the avatarImageView
        avatarImageView.contentMode = .center

        // Resize and center the avatarImageView within bounds with padding
        avatarImageView.frame = bounds
    }
}

public struct AvatarView: View {

      
    @Binding var selectedBackgroundColor: Color
    @Binding var selectedShape: String
    @Binding var selectedEyeColor: Color

    public init(selectedBackgroundColor: Binding<Color>, selectedShape: Binding<String>, selectedEyeColor: Binding<Color>) {
        self._selectedBackgroundColor = selectedBackgroundColor
        self._selectedShape = selectedShape
        self._selectedEyeColor = selectedEyeColor
    }

      public var body: some View {
          VStack {
              generateAvatar()
                  .frame(width: 150, height: 150)
          }
          .padding()
      }

      private func generateAvatar() -> some View {
          return ZStack {
              Circle()
                  .fill(selectedBackgroundColor)
                  .frame(width: 150, height: 150)

              Image(systemName: selectedShape)
                  .foregroundColor(selectedEyeColor)
                  .font(.system(size: 25))
                  .offset(x: -35, y: -15) // Offset for the left eye

              Image(systemName: selectedShape)
                  .foregroundColor(selectedEyeColor)
                  .font(.system(size: 25))
                  .offset(x: 35, y: -15) // Offset for the right eye
              
              Image(systemName: selectedShape)
                  .foregroundColor(selectedEyeColor)
                  .font(.system(size: 25))
                  .offset(x: 0, y: +30) // Offset for the right eye
          }
          .padding()
      }
}


public struct AvatarGeneratorView: UIViewRepresentable {
    public weak var delegate: AvatarGeneratorDelegate?

    @Binding public var selectedBackgroundColor: Color
    @Binding public var selectedShape: String
    @Binding public var selectedEyeColor: Color
    
    // Make the initializer public
    public init(
        delegate: AvatarGeneratorDelegate?,
        selectedBackgroundColor: Binding<Color>,
        selectedShape: Binding<String>,
        selectedEyeColor: Binding<Color>
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
    @State private var selectedBackgroundColor = Color.red
    @State private var selectedShape = "circle"
    @State private var selectedEyeColor = Color.black
    @State private var isFormShowing = false

    var body: some View {
        VStack {
            NavigationView {
                AvatarGeneratorView(
                    delegate: avatarDelegate,
                    selectedBackgroundColor: $selectedBackgroundColor,
                    selectedShape: $selectedShape,
                    selectedEyeColor: $selectedEyeColor
                )
                .navigationTitle("Avatar Generator")
            } //: NAVIGATIONVIEW
            
            Button("Show Selection From") {
                isFormShowing.toggle()
            }
            .padding()
            .sheet(isPresented: $isFormShowing, content: {
                SelectionFormView(
                    selectedBackgroundColor: $selectedBackgroundColor,
                    selectedShape: $selectedShape,
                    selectedEyeColor: $selectedEyeColor
                )
            })
        }
        .padding()
    }
}

public struct SelectionFormView: View {
    let backgroundColors = ["Red", "Green", "Blue", "Purple", "Orange"]
    let shapes = ["circle", "triangle", "square"]
    let eyeColors = ["Black", "Blue", "Green", "Gray"]
    
    @Binding public var selectedBackgroundColor: Color
    @Binding public var selectedShape: String
    @Binding public var selectedEyeColor: Color
    
    public init(
        selectedBackgroundColor: Binding<Color>,
        selectedShape: Binding<String>,
        selectedEyeColor: Binding<Color>
    ) {
        self._selectedBackgroundColor = selectedBackgroundColor
        self._selectedShape = selectedShape
        self._selectedEyeColor = selectedEyeColor
    }

    public var body: some View {
        // Your form content here, similar to AvatarView
        Form {
            Section(header: Text("Background Color")) {
                Picker("Background Color", selection: $selectedBackgroundColor) {
                    ForEach(backgroundColors, id: \.self) { colorstring in
                        if let color = Color(colorString: colorstring) {
                            Text(colorstring)
                                .tag(color)
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Shape")) {
                Picker("Shape", selection: $selectedShape) {
                    ForEach(shapes, id: \.self) { shape in
                        Text(shape.capitalized).tag(shape)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Eye Color")) {
                Picker("Eye Color", selection: $selectedEyeColor) {
                    ForEach(eyeColors, id: \.self) { colorstring in
                        if let color = Color(colorString: colorstring) {
                            Text(colorstring)
                                .tag(color)
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            AvatarView(selectedBackgroundColor: $selectedBackgroundColor, selectedShape: $selectedShape, selectedEyeColor: $selectedEyeColor)
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
                selectedBackgroundColor: .constant(Color.red),
                selectedShape: .constant("circle"),
                selectedEyeColor: .constant(Color.black)
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
                selectedShape: .constant("circle"),
                selectedEyeColor: .constant(Color.black)
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

