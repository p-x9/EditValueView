//
//  ContentView.swift
//  Example
//
//  Created by p-x9 on 2023/07/25.
//  
//

import SwiftUI
import EditValueView
import UIKit

struct ContentView: View {
    @State var target: Item = .init(name: "text",
                                    bool: false,
                                    date: Date(),
                                    enum: .red,
                                    enum2: .blue,
                                    color: .white)

    var body: some View {
        NavigationView {
            List {
                standardType
                collectionType
                codableType
                colorType
                imageType
                notSupportedType
            }
            .navigationTitle(Text("EditValueView"))
        }
    }

    var standardType: some View {
        Section {
            editValueView(title: "String", key: "name", keyPath: \.name)

            editValueView(title: "Bool", key: "bool", keyPath: \.bool)

            editValueView(title: "Date", key: "date", keyPath: \.date)

            NavigationLink("Int", destination: {
                EditValueView(
                    target,
                    key: "number",
                    keyPath: \Item.codable.number,
                    presentationStyle: .push
                )
                .onUpdate { newValue in
                    target.codable.number = newValue
                }
                .validate { newValue in
                    newValue.isMultiple(of: 2)
                }
            })

            NavigationLink("Double") {
                EditValueView(
                    target,
                    key: "double",
                    keyPath: \Item.codable.double,
                    presentationStyle: .push
                )
                .onUpdate { newValue in
                    target.codable.double = newValue
                }
                .validate { newValue in
                    newValue > 0
                }
            }
        } header: {
            Text("Standard")
        }
    }

    var collectionType: some View {
        Section {
            editValueView(title: "CaseIterable", key: "enum", keyPath: \.enum)

            editValueView(title: "CaseIterable & RawRepresentable", key: "enum2", keyPath: \.enum2)

            editValueView(title: "Array", key: "array", keyPath: \.array)

            editValueView(title: "Dictionary", key: "dictionary", keyPath: \.dictionary)
        } header: {
            Text("Collection")
        }
    }

    var codableType: some View {
        Section {
            editValueView(title: "Codable", key: "codable", keyPath: \.codable)
        } header: {
            Text("Codable")
        }
    }

    var colorType: some View {
        Section {
            editValueView(title: "Color", key: "color", keyPath: \.color)

            editValueView(title: "UI/NSColor", key: "ui/nsColor", keyPath: \.uiColor)

            editValueView(title: "CGColor", key: "cgColor", keyPath: \.cgColor)

            editValueView(title: "CIColor", key: "ciColor", keyPath: \.ciColor)
        } header: {
            Text("Color")
        }
    }

    var imageType: some View {
        Section {
            editValueView(title: "Image", key: "image", keyPath: \.image)

            editValueView(title: "NS/UIImage", key: "ns/uiImage", keyPath: \.nsuiImage)

            editValueView(title: "CGImage", key: "cgImage", keyPath: \.cgImage)

            editValueView(title: "CIImage", key: "ciImage", keyPath: \.ciImage)
        } header: {
            Text("Image")
        }
    }

    var notSupportedType: some View {
        Section {
            NavigationLink("Not Supported") {
                EditValueView(key: "item",
                              binding: $target,
                              presentationStyle: .push)
            }
        } header: {
            Text("Not Supported")
        }
    }

    func editValueView<Value>(
        title: String,
        key: String,
        keyPath: WritableKeyPath<Item, Value>
    ) -> NavigationLink<Text, EditValueView<Value>> {
        NavigationLink(title) {
            EditValueView(
                target,
                key: key,
                keyPath: keyPath,
                presentationStyle: .push
            )
            .onUpdate { newValue in
                target[keyPath: keyPath] = newValue
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Enum: CaseIterable {
    case red, yellow, blue
}
enum Enum2: Int, CaseIterable, DefaultRepresentable {
    case red, yellow, blue

    static var defaultValue: Self {
        .red
    }
}
struct Item {
    var name: String
    var bool: Bool
    var date: Date?
    var `enum`: Enum
    var enum2: Enum2?
    var color: Color
    var `codable`: ACodable = .init(text: "", number: 5)
    var array = ["AA", "BB"]
    var dictionary: [String: Int] = [
        "AA": 0,
        "BB": 234
    ]
    var cgColor = UIColor.yellow.cgColor
    var uiColor = UIColor.blue
    var ciColor = CIColor(color: UIColor.brown)

    var image: Image = .init(systemName: "swift")
    var nsuiImage = UIImage(systemName: "swift")
    var cgImage = UIImage(systemName: "swift")?.cgImage
    var ciImage = UIImage(systemName: "swift")?.ciImage
}

struct ACodable: Codable {
    var text: String
    var number: Int
    var double: Double = 0.4
    var optionalString: String? = "test"
    var nested: BCodable = .init(text: "", number: 0)
}

extension ACodable: DefaultRepresentable {
    static var defaultValue: ACodable = .init(text: "", number: 0)
}

struct BCodable: Codable {
    var text: String
    var number: Int
    var optionalString: String?
}
