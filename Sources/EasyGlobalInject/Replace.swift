public func replace<T>(_ type: T.Type, _ completion: @escaping (T) -> T) {
    GlobalContainer.shared.replace(type, completion)
}
