//
//  PancakeEntity.swift
//  TestingARKit
//
//  Created by thaxz on 01/10/23.
//

import Foundation
import Combine
import RealityKit

final class PancakeEntity: Entity {
    var model: Entity?
    
    static var loadAsync: AnyPublisher<PancakeEntity, Error> {
        return Entity.loadAsync(named: "pancakes")
            .map { loadedPancake -> PancakeEntity in
                let pancake = PancakeEntity()
                loadedPancake.name = "Pancake"
                pancake.model = loadedPancake
                return pancake
            }
            .eraseToAnyPublisher()
    }
}
