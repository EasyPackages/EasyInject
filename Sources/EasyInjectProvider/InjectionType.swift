import EasyInject

enum InjectionType {
    case single(Any)
    case build(InjectorFactory<Any>)
}
