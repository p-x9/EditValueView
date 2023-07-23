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

public class EditValueViewController<Root, Value>: UIViewController {

    let key: String

    public var onUpdate: ((Value) -> Void)?
    public var validate: ((Value) -> Bool)?

    private var editValueView: EditValueView<Root, Value>

    public init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Value>) {
        self.key = key

        self.editValueView = .init(target, key: key, keyPath: keyPath)

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
