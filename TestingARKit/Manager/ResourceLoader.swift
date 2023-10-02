//
//  ResourceLoader.swift
//  TestingARKit
//
//  Created by thaxz on 02/10/23.
//

import Foundation
import Combine
import RealityKit

class ResourceLoader {
    
    typealias LoadCompletion = (Result<PancakeEntity, Error>) -> Void
    
    private var loadCancellable: AnyCancellable?
    private var pancakeEntity: PancakeEntity?
    
    // LOAD
    func loadResources(completion: @escaping LoadCompletion) -> AnyCancellable? {
        guard let pancakeEntity else {
            loadCancellable = PancakeEntity.loadAsync.sink { result in
                if case let .failure(error) = result {
                    print("Failed to load PancakeEntity: \(error)")
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] pancakeEntity in
                guard let self else {
                    return
                }
                self.pancakeEntity = pancakeEntity
                completion(.success(pancakeEntity))
            }
            return loadCancellable
        }
        completion(.success(pancakeEntity))
        return loadCancellable
    }
    
    // CREATE
    func createPancake() throws -> Entity {
        guard let pancake = pancakeEntity?.model else {
            throw ResourceLoaderError.resourceNotLoaded
        }
        return pancake.clone(recursive: true)
    }
}

enum ResourceLoaderError: Error {
    case resourceNotLoaded
}
