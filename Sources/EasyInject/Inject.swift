public func inject<T>(_ type: T.Type? = nil) -> T? {
    GlobalContainer.shared.resolve(T.self)
}
