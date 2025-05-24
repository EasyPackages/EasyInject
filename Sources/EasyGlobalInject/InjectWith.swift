public func injectWith<T>(_ type: T.Type, _ completion: (T) -> T) -> T? {
    GlobalContainer.shared.injectWith(type, completion)
}
