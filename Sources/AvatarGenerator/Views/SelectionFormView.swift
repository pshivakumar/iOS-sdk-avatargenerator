//
//  SelectionFormView.swift
//
//
//  Created by shiva kumar on 24/12/23.
//

import SwiftUI

public struct SelectionFormView: View {
    let backgroundColors = ["Red", "Green", "Blue", "Purple", "Orange"]
    let eyeShapes = ["circle", "triangle", "square"]
    let mouthShapes = ["infinity", "hockey.puck", "phone.down"]
    let eyeColors = ["Black", "Blue", "Green", "Gray"]
    
    @Binding public var selectedBackgroundColor: Color
    @Binding public var selectedEyeShape: String
    @Binding public var selectedMouthShape: String
    @Binding public var selectedShapeColor: Color
    
    public init(
        selectedBackgroundColor: Binding<Color>,
        selectedEyeShape: Binding<String>,
        selectedMouthShape: Binding<String>,
        selectedShapeColor: Binding<Color>
    ) {
        self._selectedBackgroundColor = selectedBackgroundColor
        self._selectedEyeShape = selectedEyeShape
        self._selectedMouthShape = selectedMouthShape
        self._selectedShapeColor = selectedShapeColor
    }

    public var body: some View {
        VStack {
            // 1. Drag Indicator
            Capsule()
                .fill(Color.secondary)
                .opacity(0.6)
                .frame(width: 40, height: 5)
                .padding(20)
            
            // 2. Form View
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

                Section(header: Text("Eye Shape")) {
                    Picker("Shape", selection: $selectedEyeShape) {
                        ForEach(eyeShapes, id: \.self) { shape in
                            Image(systemName: shape).tag(shape)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Mouth Shape")) {
                    Picker("Shape", selection: $selectedMouthShape) {
                        ForEach(mouthShapes, id: \.self) { shape in
                            Image(systemName: shape).tag(shape)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Eye/Mouth Color")) {
                    Picker("Eye Color", selection: $selectedShapeColor) {
                        ForEach(eyeColors, id: \.self) { colorstring in
                            if let color = Color(colorString: colorstring) {
                                Text(colorstring)
                                    .tag(color)
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                AvatarView(selectedBackgroundColor: $selectedBackgroundColor, selectedEyeShape: $selectedEyeShape, selectedShapeColor: $selectedShapeColor, selectedMouthShape: $selectedMouthShape)
            } //: FORM
        } //: VSTACK
    }
}

#Preview {
    SelectionFormView(selectedBackgroundColor: .constant(.red), selectedEyeShape: .constant("circle"), selectedMouthShape: .constant("phone.down"), selectedShapeColor: .constant(.black))
}
