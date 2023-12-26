//
//  AvatarView.swift
//
//
//  Created by shiva kumar on 24/12/23.
//

import SwiftUI

public struct AvatarView: View {
    @Binding var selectedBackgroundColor: Color
    @Binding var selectedEyeShape: String
    @Binding var selectedShapeColor: Color
    @Binding var selectedMouthShape: String

    public init(selectedBackgroundColor: Binding<Color>, selectedEyeShape: Binding<String>, selectedShapeColor: Binding<Color>, selectedMouthShape: Binding<String>) {
        self._selectedBackgroundColor = selectedBackgroundColor
        self._selectedEyeShape = selectedEyeShape
        self._selectedShapeColor = selectedShapeColor
        self._selectedMouthShape = selectedMouthShape
    }

      public var body: some View {
          VStack {
              HStack {
                  Spacer()
                  generateAvatar()
                      .frame(width: 150, height: 150)
                  Spacer()
              }
          }
          .padding()
      }

      private func generateAvatar() -> some View {
          return ZStack {
              Circle()
                  .fill(selectedBackgroundColor)
                  .frame(width: 150, height: 150) // Shape of the face

              Image(systemName: selectedEyeShape)
                  .foregroundColor(selectedShapeColor)
                  .font(.system(size: 25))
                  .offset(x: -35, y: -15) // Offset for the left eye

              Image(systemName: selectedEyeShape)
                  .foregroundColor(selectedShapeColor)
                  .font(.system(size: 25))
                  .offset(x: 35, y: -15) // Offset for the right eye
              
              Image(systemName: selectedMouthShape)
                  .foregroundColor(selectedShapeColor)
                  .font(.system(size: 30))
                  .offset(x: 0, y: +30) // Offset for the mouth
          }
          .padding()
      }
}

#Preview {
    AvatarView(selectedBackgroundColor: .constant(.green), selectedEyeShape: .constant("circle"), selectedShapeColor: .constant(.black), selectedMouthShape: .constant("infinity"))
}
