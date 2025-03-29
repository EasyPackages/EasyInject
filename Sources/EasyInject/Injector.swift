public protocol Injector {
    func register<T>(_ instance: T, for type: T.Type)
    func register<T>(for type: T.Type, factory: @escaping InjectorFactory<T>)
    func resolve<T>(for type: T.Type) -> T?
}
