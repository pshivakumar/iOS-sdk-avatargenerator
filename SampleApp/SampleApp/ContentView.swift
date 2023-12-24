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
            Text("Avatar Image ")
                .font(.title)
                .fontWeight(.bold)
            
            AvatarGeneratorView(delegate: avatarDelegate, selectedBackgroundColor: $selectedBackgroundColor, selectedEyeShape: $selectedEyeShape, selectedShapeColor: $selectedShapeColor, selectedMouthShape: $selectedMouthShape)
                .frame(width: 300, height: 300)
            
            Button("Show Options") {
                isShowingForm.toggle()
            }
            .padding()
            .sheet(isPresented: $isShowingForm, content: {
                SelectionFormView(selectedBackgroundColor: $selectedBackgroundColor, selectedEyeShape: $selectedEyeShape, selectedMouthShape: $selectedMouthShape, selectedShapeColor: $selectedShapeColor)
            })
        }
    }
}

#Preview {
    ContentView()
}
