public func injectWith<T>(_ type: T.Type? = nil, _ completion: (T) -> T) -> T? {
    GlobalContainer.shared.injectWith(type, completion)
}
