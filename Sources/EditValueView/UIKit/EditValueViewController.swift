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
    
    let target: Root
    let key: String
    let keyPath: PartialKeyPath<Root> // WritableKeyPath<Root, Value>
    
    public var onUpdate: ((Root, Value) -> Void)?
    public var validate: ((Root, Value) -> Bool)?
    
    private var isWrappedOptional = false
    
    private var editValueView: EditValueView<Root, Value>

    @_disfavoredOverload
    public init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Value>) {
        self.target = target
        self.key = key
        self.keyPath = keyPath
        
        self.editValueView = .init(target, key: key, keyPath: keyPath)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Optional<Value>>, defaultValue: Value) {
        self.target = target
        self.key = key
        self.keyPath = keyPath
        self.isWrappedOptional = true
        
        self.editValueView = .init(target, key: key, keyPath: keyPath, defaultValue: defaultValue)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(_ target: Root, key: String, keyPath: WritableKeyPath<Root, Optional<Value>>) where Value: DefaultRepresentable {
        self.init(target, key: key, keyPath: keyPath, defaultValue: Value.defaultValue)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildViewController()
    }
    
    private func setupChildViewController() {
        editValueView = editValueView
            .onUpdate { [weak self] target, value in
                self?.onUpdate?(target, value)
            }
            .validate { [weak self] target, value in
                self?.validate?(target, value) ?? true
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
