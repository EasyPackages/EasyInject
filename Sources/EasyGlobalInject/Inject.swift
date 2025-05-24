public func inject<T>(_ type: T.Type) -> T? {
    GlobalContainer.shared.inject(type)
}
