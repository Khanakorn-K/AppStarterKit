//
//  Weak.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//

import Foundation
@propertyWrapper
public final class Weak<T:AnyObject>{
    private weak var _wrappedValue : T?
    public var wrappedValue : T?{
        get{_wrappedValue}
        set{_wrappedValue = newValue}
    }
    public  init(wrappedValue: T? = nil){
        self._wrappedValue = wrappedValue
    }
}
