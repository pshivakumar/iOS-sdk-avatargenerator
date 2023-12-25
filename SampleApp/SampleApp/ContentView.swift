//
//  ContentView.swift
//  SampleApp
//
//  Created by shiva kumar on 21/12/23.
//

import SwiftUI
import AvatarGenerator

struct ContentView: View {
    @StateObject private var avatarDelegate = AvatarGeneratorDelegateImpl()
    @State private var selectedBackgroundColor = Color.green
    @State private var selectedEyeShape = "circle"
    @State private var selectedMouthShape = "infinity"
    @State private var selectedShapeColor = Color.black
    @State private var isShowingForm = false

    var body: some View {
        VStack {
            Text("Avatar Image")
                .font(.title)
                .fontWeight(.bold)
            
            AvatarGeneratorView(delegate: avatarDelegate, selectedBackgroundColor: $selectedBackgroundColor, selectedEyeShape: $selectedEyeShape, selectedShapeColor: $selectedShapeColor, selectedMouthShape: $selectedMouthShape)
                .frame(width: 250, height: 250)
            
            Button("Make my Avatar") {
                isShowingForm.toggle()
            }
            .padding()
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .sheet(isPresented: $isShowingForm, content: {
                SelectionFormView(selectedBackgroundColor: $selectedBackgroundColor, selectedEyeShape: $selectedEyeShape, selectedMouthShape: $selectedMouthShape, selectedShapeColor: $selectedShapeColor)
            })
        }
    }
}

#Preview {
    ContentView()
}
