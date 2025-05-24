public func inject<T>(_ type: T.Type? = nil) -> T? {
    GlobalContainer.shared.inject(type)
}
