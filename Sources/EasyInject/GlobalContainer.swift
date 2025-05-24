import Foundation

final class GlobalContainer: @unchecked Sendable {
    static let shared = GlobalContainer()

    private var dependencies = [ObjectIdentifier: Any]()
    
    private let queue = DispatchQueue(
        label: Bundle.main
            .bundleIdentifier?
            .appending(".easyinject.injector") ?? String(),
        attributes: .concurrent
    )
    
    private init() {
        // Singleton
    }
    
    func register<T>(_ instance: T, for type: T.Type) {
        queue.sync(flags: .barrier) {
            dependencies[ObjectIdentifier(type)] = instance
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        queue.sync {
            dependencies[ObjectIdentifier(type)] as? T
        }
    }
}
