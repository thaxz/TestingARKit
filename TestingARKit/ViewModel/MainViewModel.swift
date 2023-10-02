//
//  MainViewModel.swift
//  TestingARKit
//
//  Created by thaxz on 02/10/23.
//

import Foundation
import Combine
import ARKit
import RealityKit

final class ViewModel: NSObject, ObservableObject {
    // Allow loading to take a minimum amount of time, to ease state transitions
    private static let loadBuffer: TimeInterval = 2
    
    private let resourceLoader = ResourceLoader()
    private var loadCancellable: AnyCancellable?
    
    // Anchors
    private var anchors = [UUID: AnchorEntity]()
    
    @Published var assetsLoaded = false

    func resume() {
        if !assetsLoaded && loadCancellable == nil {
            loadAssets()
        }
    }

    func pause() {
        loadCancellable?.cancel()
        loadCancellable = nil
    }
    
    // Add objects to the scene
    func addPancake(anchor: ARAnchor,
                   at worldTransform: simd_float4x4,
                   in view: ARView) {
           // Create a new cup to place at the tap location
           let pancake: Entity
           do {
               pancake = try resourceLoader.createPancake()
           } catch let error {
               print("Failed to create pancake: \(error)")
               return
           }
           
           defer {
               // Get translation from transform
               let column = worldTransform.columns.3
               let translation = SIMD3<Float>(column.x, column.y, column.z)
               
               // Move the cup to the tap location
               pancake.setPosition(translation, relativeTo: nil)
           }
           
           // If there is not already an anchor here, create one
           guard let anchorEntity = anchors[anchor.identifier] else {
               let anchorEntity = AnchorEntity(anchor: anchor)
               anchorEntity.addChild(pancake)
               view.scene.addAnchor(anchorEntity)
               anchors[anchor.identifier] = anchorEntity
               return
           }
           
           // Add the cup to the existing anchor
           anchorEntity.addChild(pancake)
       }
    
    // MARK: - Private methods

    private func loadAssets() {
        let beforeTime = Date().timeIntervalSince1970
        loadCancellable = resourceLoader.loadResources { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case let .failure(error):
                print("Failed to load assets \(error)")
            case .success:
                let delta = Date().timeIntervalSince1970 - beforeTime
                var buffer = Self.loadBuffer - delta
                if buffer < 0 {
                    buffer = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + buffer) {
                    self.assetsLoaded = true
                }
            }
        }
    }
}
