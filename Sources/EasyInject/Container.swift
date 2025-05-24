protocol Container {
    func inject<T>(_ type: T.Type) -> T?
    func injectWith<T>(_ type: T.Type, _ completion: (T) -> T) -> T?
    func replace<T>(_ type: T.Type, _ completion: @escaping (T) -> T)
    func registry<T>(_ instance: T, for type: T.Type) -> T
}
