import Testing

import EasyInject

@Suite("Dependency Injection", .serialized)
struct DependencyInjectionTests {
    
    @Test("Injecting an unregistered type should return nil")
    func testInjectUnregisteredType() {
        let received: String? = inject()
        
        #expect(received == nil)
    }
    
    @Test("Injecting with a transformation on an unregistered type should return nil")
    func testInjectWithUnregisteredType() {
        let received: String? = injectWith { _ in String() }
        
        #expect(received == nil)
    }
    
    @Test("Registering and injecting a type should return the registered instance")
    func testRegisterAndInjectType() {
        let str = "dummy"
        
        registry(str, for: String.self)
        let received: String = inject()!
        
        #expect(received == str)
    }
    
    @Test("Registering a type multiple times should return the last registered instance")
    func testRegisterTypeMultipleTimes() {
        let str = "any-other-dummy"
        
        registry("dummy", for: String.self)
        registry(str, for: String.self)
        let received: String? = inject()
        
        #expect(received == str)
    }
    
    @Test("Replacing a registered type should return the transformed instance")
    func testReplaceRegisteredType() {
        let old = "dummy"
        let new = "any-other-dummy"
        
        registry(old, for: String.self)
        replace(String.self) { old in
            old + "+" + new
        }
        
        let received: String? = inject()
        
        #expect(received == "\(old)+\(new)")
    }
    
    @Test("Injecting with transformation should not affect the original registered instance")
    func testInjectWithTransformation() {
        let old = "old"
        let new = "new"
        registry(old, for: String.self)
        
        let received: String? = injectWith { old in
            old + "+" + new
        }
        
        #expect(received == "\(old)+\(new)")
        #expect(inject(String.self) == old)
    }
    
    @Test("Injecting with transformation should work with multiple registrations")
    func testInjectWithTransformationMultipleRegistrations() {
        let old = "old"
        let new = "new"
        registry("dummy", for: String.self)
        registry(old, for: String.self)
        
        let received: String? = injectWith { old in
            old + "+" + new
        }
        
        #expect(received == "\(old)+\(new)")
        #expect(inject(String.self) == old)
    }
}
