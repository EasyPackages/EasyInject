public func injectWith<T>(_ type: T.Type? = nil, _ completion: (T) -> T) -> T? {
    guard let old = GlobalContainer.shared.resolve(T.self) else {
        return nil
    }
    
    return completion(old)
}
