import Foundation
import Testing

@testable import EasyInjectProvider

@Suite("Dependency Injector")
struct DependencyInjectorTests {
    
    @Test("Given no dependency is registered, When resolving it, Then it should return nil")
    func givenNoDependencyRegisteredWhenResolvingThenReturnsNil() {
        let sut = DependencyInjector()
        let resolvedDependency = sut.resolve(for: Dependency.self)
        #expect(resolvedDependency == nil)
    }
    
    @Test("Given a dependency is registered, When resolving it, Then it should return the registered instance")
    func givenDependencyRegisteredWhenResolvingThenReturnsRegisteredInstance() {
        let dependency = DependencyDummy()
        let sut = DependencyInjector()
        sut.register(dependency, for: Dependency.self)
        
        let resolvedDependency = sut.resolve(for: Dependency.self)
        #expect(resolvedDependency?.id == dependency.id)
    }
    
    @Test("Given a dependency is registered, When registering a new one, Then it should override the previous")
    func givenDependencyAlreadyRegisteredWhenRegisteringNewThenOverridesPrevious() {
        let dependency1 = DependencyDummy()
        let dependency2 = DependencyDummy()
        let sut = DependencyInjector()
        sut.register(dependency1, for: Dependency.self)
        sut.register(dependency2, for: Dependency.self)
        
        let resolvedDependency = sut.resolve(for: Dependency.self)
        #expect(resolvedDependency?.id != dependency1.id)
        #expect(resolvedDependency?.id == dependency2.id)
    }
    
    @Test("Given a factory is registered, When resolving the dependency, Then it should return the created instance")
    func givenFactoryRegisteredWhenResolvingThenReturnsCreatedInstance() {
        let id = UUID()
        let sut = DependencyInjector()
        sut.register(for: Dependency.self) { _ in
            DependencyDummy(id: id)
        }
        
        let resolvedDependency = sut.resolve(for: Dependency.self)
        #expect(resolvedDependency?.id == id)
    }
    
    @Test("Given a factory is registered, When another factory is registered, Then it should override the previous one")
    func givenFactoryAlreadyRegisteredWhenRegisteringNewFactoryThenOverridesPrevious() {
        let id = UUID()
        let sut = DependencyInjector()
        sut.register(for: Dependency.self) { _ in
            DependencyDummy()
        }
        sut.register(for: Dependency.self) { _ in
            DependencyDummy(id: id)
        }
        
        let resolvedDependency = sut.resolve(for: Dependency.self)
        #expect(resolvedDependency?.id == id)
    }
    
    @Test("Given a dependency is registered, When using it inside another factory, Then it should resolve correctly")
    func givenDependencyRegisteredWhenUsedInsideFactoryThenResolvesCorrectly() {
        let sut = DependencyInjector()
        sut.register(for: Dependency.self) { _ in
            DependencyDummy()
        }
        sut.register(for: Codable.self) { injector in
            String(describing: type(of: injector.resolve(for: Dependency.self)!))
        }
        
        let resolvedDependency = sut.resolve(for: Codable.self)
        #expect(resolvedDependency as? String == "DependencyDummy")
    }
    
    @Test("Given a dependency is registered as instance, When used inside another factory, Then it should resolve correctly")
    func givenInstanceRegisteredWhenUsedInsideFactoryThenResolvesCorrectly() {
        let sut = DependencyInjector()
        sut.register(DependencyDummy(), for: Dependency.self)
        sut.register(for: Codable.self) { injector in
            String(describing: type(of: injector.resolve(for: Dependency.self)!))
        }
        
        let resolvedDependency = sut.resolve(for: Codable.self)
        #expect(resolvedDependency as? String == "DependencyDummy")
    }
    
    @Test("Given a registered dependency, When multiple concurrent factory registrations occur, Then resolution should still return the correct instance")
    func givenDependencyRegistered_whenRegisteringCodableConcurrently_thenReturnsCorrectInstance() async {
        let id = UUID()
        let sut = DependencyInjector()
        sut.register(DependencyDummy(id: id), for: Dependency.self)

        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< 10 {
                group.addTask {
                    sut.register(for: Codable.self) { injector in
                        injector.resolve(for: Dependency.self)!.id.uuidString
                    }
                }
            }
        }

        let resolvedDependency = sut.resolve(for: Codable.self)
        #expect(resolvedDependency as? String == id.uuidString)
    }
    
    @Test("Given no prior registration, When registering the same instance concurrently, Then resolution should return the correct one")
    func givenNoDependencyRegistered_whenRegisteringSameInstanceConcurrently_thenResolvesCorrectly() async {
        let id = UUID()
        let sut = DependencyInjector()
        
        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< 10 {
                group.addTask {
                    sut.register(DependencyDummy(id: id), for: Dependency.self)
                }
            }
        }

        let resolvedDependency = sut.resolve(for: Dependency.self)
        #expect(resolvedDependency?.id == id)
    }
}
