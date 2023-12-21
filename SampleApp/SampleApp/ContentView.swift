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

    var body: some View {
        VStack {
            Text("Avatar Image ")
                .font(.title)
                .fontWeight(.bold)
            
            AvatarGeneratorView(delegate: avatarDelegate, selectedBackgroundColor: .constant(UIColor.red), selectedShape: .constant("circle"), selectedEyeColor: .constant(UIColor.black))
        }
    }
}

#Preview {
    ContentView()
}
