import Foundation

import EasyInject

public final class GlobalContainer: @unchecked Sendable, Container {
    public static let shared = GlobalContainer()

    fileprivate var dependencies = [ObjectIdentifier: Any]()
    
    private let queue = DispatchQueue(
        label: Bundle.main
            .bundleIdentifier?
            .appending(".easyinject.injector") ?? String(),
        attributes: .concurrent
    )
    
    public init() {
        clean()
    }
    
    private func register<T>(_ instance: T, for type: T.Type) {
        queue.sync(flags: .barrier) {
            dependencies[ObjectIdentifier(type)] = instance
        }
    }
    
    private func resolve<T>(_ type: T.Type) -> T? {
        queue.sync {
            dependencies[ObjectIdentifier(type)] as? T
        }
    }
    
    public func inject<T>(_ type: T.Type) -> T? {
        resolve(T.self)
    }

    public func injectWith<T>(_ type: T.Type, _ completion: (T) -> T) -> T? {
        guard let old = resolve(T.self) else {
            return nil
        }
        
        return completion(old)
    }
    
    public func registry<T>(_ instance: T, for type: T.Type) -> T {
        register(instance, for: type)
        return instance
    }
    
    public func replace<T>(_ type: T.Type, _ completion: @escaping (T) -> T) {
        let old = resolve(type)!
        register(completion(old), for: type)
    }
    
    public func clean() {
        dependencies = [:]
    }
}
