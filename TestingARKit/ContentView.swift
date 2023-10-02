//
//  ContentView.swift
//  TestingARKit
//
//  Created by thaxz on 01/10/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ZStack {
            // Fullscreen camera ARView
            ARViewContainer().edgesIgnoringSafeArea(.all)
            // Loading screen
            ZStack {
                Color.white
                Text("Loading resources...")
                    .foregroundColor(Color.black)
            }
            .opacity(viewModel.assetsLoaded ? 0 : 1)
            .ignoresSafeArea()
            .animation(Animation.default.speed(1),
                       value: viewModel.assetsLoaded)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ContentView_Previews : PreviewProvider {
    @StateObject static var viewModel: ViewModel = {
        return ViewModel()
    }()
    
    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
    }
}

