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

public class EditValueViewController<Value>: UIViewController {

    /// Name of the property to be edited
    /// Used for navigation titles and type descriptions.
    let key: String

    /// This is called when editing is completed by pressing the save button.
    public var onUpdate: ((Value) -> Void)?

    /// Used to perform validation checks when editing values
    public var validate: ((Value) -> Bool)?

    private var editValueView: EditValueView<Value>

    /// Initialize with key and value
    /// - Parameters:
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - value: Initial value of the value to be edited
    public init<Root>(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Value>) {
        self.key = key

        self.editValueView = .init(target, key: key, keyPath: keyPath)

        super.init(nibName: nil, bundle: nil)
    }

    /// initialize with keyPath
    /// - Parameters:
    ///   - target: Target object that has the property to be edited.
    ///   - key: Name of the property to be edited. Used for navigation titles and type descriptions.
    ///   - keyPath: keyPath of the property to be edited.
    public init(key: String, value: Value) {
        self.key = key

        self.editValueView = .init(key: key, value: value)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupChildViewController()
    }

    private func setupChildViewController() {
        editValueView = editValueView
            .onUpdate { [weak self] value in
                self?.onUpdate?(value)
            }
            .validate { [weak self] value in
                self?.validate?(value) ?? true
            }

        let vc = UIHostingController(rootView: editValueView)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            vc.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

#endif
