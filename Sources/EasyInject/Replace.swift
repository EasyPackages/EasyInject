public func replace<T>(_ type: T.Type, _ completion: @escaping (T) -> T) {
    let old = GlobalContainer.shared.resolve(type)!
    GlobalContainer.shared.register(completion(old), for: type)
}
