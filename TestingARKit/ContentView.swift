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
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
                
        // Configure the session
        viewModel.configureSession(forView: arView)
        
        // Capture taps into the ARView
        context.coordinator.arView = arView
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.viewTapped(_:)))
        tapRecognizer.name = "ARView Tap"
        arView.addGestureRecognizer(tapRecognizer)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator: NSObject {
        weak var arView: ARView?
        let parent: ARViewContainer
        
        init(parent: ARViewContainer) {
            self.parent = parent
        }

        @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            guard let arView,
                  let result = arView.raycast(from: point,
                                              allowing: .existingPlaneGeometry,
                                              alignment: .horizontal).first,
                  let anchor = result.anchor
            else {
                return
            }
            parent.viewModel.addPancake(anchor: anchor,
                                    at: result.worldTransform,
                                    in: arView)
        }
    }

    func makeCoordinator() -> ARViewContainer.Coordinator {
        return Coordinator(parent: self)
    }
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

