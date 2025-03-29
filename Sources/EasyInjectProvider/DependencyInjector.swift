import Foundation

import EasyInject

public final class DependencyInjector: @unchecked Sendable, Injector {
    private var dependencies = [ObjectIdentifier: InjectionType]()
    
    private let queue = DispatchQueue(
        label: Bundle.main
            .bundleIdentifier?
            .appending(".easyinject.injector") ?? String(),
        attributes: .concurrent
    )
    
    public func register<T>(_ instance: T, for type: T.Type) {
        queue.sync(flags: .barrier) {
            dependencies[ObjectIdentifier(type)] = .single(instance)
        }
    }
    
    public func register<T>(for type: T.Type, factory: @escaping InjectorFactory<T>) {
        queue.sync(flags: .barrier) {
            dependencies[ObjectIdentifier(type)] = .build(factory)
        }
    }
    
    public func resolve<T>(for type: T.Type) -> T? {
        queue.sync {
            switch dependencies[ObjectIdentifier(type)] {
            case .single(let instance):
                return instance as? T
            case .build(let factory):
                return factory(self) as? T
            case .none:
                return nil
            }
        }
    }
}
