//
//  EditValueViewController.swift
//  
//
//  Created by p-x9 on 2022/10/28.
//  
//

#if canImport(UIKit)
import UIKit
import SwiftUI

public class EditValueViewController<Value>: UIHostingController<EditValueView<Value>> {

    /// Name of the property to be edited
    /// Used for navigation titles and type descriptions.
    let key: String

    /// This is called when editing is completed by pressing the save button.
    public var onUpdate: ((Value) -> Void)?

    /// Used to perform validation checks when editing values
    public var validate: ((Value) -> Bool)?

    /// Initialize with key and value
    /// - Parameters:
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - value: Initial value of the value to be edited
    public init<Root>(
        _ target: Root,
        key: String,
        keyPath: WritableKeyPath<Root, Value>
    ) {
        self.key = key

        super.init(rootView: .init(target, key: key, keyPath: keyPath))

        rootView = rootView
            .onUpdate({ newValue in
                self.onUpdate?(newValue)
            })
            .validate({ newValue in
                self.validate?(newValue) ?? true
            })
    }

    /// initialize with keyPath
    /// - Parameters:
    ///   - target: Target object that has the property to be edited.
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - keyPath: keyPath of the property to be edited.
    public init(key: String, value: Value) {
        self.key = key

        super.init(rootView: .init(key: key, value: value))

        rootView = rootView
            .onUpdate({ newValue in
                self.onUpdate?(newValue)
            })
            .validate({ newValue in
                self.validate?(newValue) ?? true
            })
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let style: EditValueView<Value>.PresentationStyle

        if navigationController == nil {
            style = .modal
        } else {
            style = .push
        }

        rootView = rootView
            .presentationStyle(style)
    }
}

#endif
