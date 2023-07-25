//
//  ImageEditor.swift
//  
//
//  Created by p-x9 on 2023/07/25.
//  
//

import SwiftUI

#if canImport(UIKit)
struct ImageEditor<Value>: View {
    enum SourceType: Int, Identifiable {
        case library
        case camera

        var id: Int { rawValue }

        var type: UIImagePickerController.SourceType {
            switch self {
            case .library: return .photoLibrary
            case .camera: return .camera
            }
        }
    }

    @Binding var value: Value

    @State var image: NSUIImage
    @State var sourceTypeOfPicker: SourceType?
    @State var isPresentedActionSheet = false

    init(_ value: Binding<Value>) {
        self._value = value

        guard let nsuiImage = Self.toNSUIImage(value.wrappedValue) else {
            fatalError("not supported")
        }

        _image = .init(initialValue: nsuiImage)
    }

    var body: some View {
        VStack {
            HStack {
                Text("tap to select image")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Spacer()
            }

            imageView
                .onTapGesture {
                    isPresentedActionSheet = true
                }
                .onChange(of: image) { newValue in
                    imageChanged(newValue)
                }
        }
        .sheet(item: $sourceTypeOfPicker) { type in
            ImagePicker(sourceType: type.type, selectedImage: .init($image))
        }
        .actionSheet(isPresented: $isPresentedActionSheet) {
            actionSheet
        }
    }

    var imageView: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .padding()
            .border(.black, width: 0.5)
    }

    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Button"),
            buttons: [
                .default(Text("Photo Library")) {
                    sourceTypeOfPicker = .library
                },
                .default(Text("Camera")) {
                    sourceTypeOfPicker = .camera
                },
                .cancel()

            ]
        )
    }
}

extension ImageEditor {
    func imageChanged(_ nsuiImage: NSUIImage) {
        switch Value.self {
        case is NSUIImage.Type:
            value = nsuiImage as! Value
            break

        case is CIImage.Type:
            if let v = nsuiImage.ciImage {
                value = v as! Value
            }

        case is CGImage.Type:
            if let v = nsuiImage.cgImage {
                value = v as! Value
            }

        default:
            break
        }
    }
}

extension ImageEditor {
    
    static func toNSUIImage(_ value: Value) -> NSUIImage? {
        switch value {
        case let v as NSUIImage:
            return v

        case let v as CIImage:
            return .init(ciImage: v)

        case let v as CGImage where Value.self is CGImage.Type:
            return .init(cgImage: v)

        default:
            return nil
        }
    }
}

#endif
