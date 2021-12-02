
public struct ExtensionWrapper<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionCompatible: AnyObject { }

public protocol ExtensionCompatibleValue {}

extension ExtensionCompatible {
    /// Gets a namespace holder for ADExtensionKit compatible types.
    public var ext: ExtensionWrapper<Self> {
        get { return ExtensionWrapper(self) }
        set { }
    }
    
    public static var ext: ExtensionWrapper<Self>.Type {
        get{ ExtensionWrapper<Self>.self }
        set {}
    }
    
}

extension ExtensionCompatibleValue {
    /// Gets a namespace holder for ADExtensionKit compatible types.
    public var ext: ExtensionWrapper<Self> {
        get { return ExtensionWrapper(self) }
        set { }
    }
    
    public static var ext: ExtensionWrapper<Self>.Type {
        get{ ExtensionWrapper<Self>.self }
        set {}
    }
    
}

