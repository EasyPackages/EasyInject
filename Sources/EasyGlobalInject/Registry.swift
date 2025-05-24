@discardableResult
public func registry<T>(_ instance: T, for type: T.Type) -> T {
    GlobalContainer.shared.registry(instance, for: type)
}
