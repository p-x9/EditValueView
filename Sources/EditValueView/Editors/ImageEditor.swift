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

    @State var image: NSUIImage?
    @State var sourceTypeOfPicker: SourceType?
    @State var isPresentedActionSheet = false
    @State var isPresentedFileImporter = false

    /// A boolean value that indicates whether the type being edited is an Optional type or not
    var isOptional: Bool {
        Value.self is any OptionalType.Type
    }

    init(_ value: Binding<Value>) {
        self._value = value

        let nsuiImage = Self.toNSUIImage(value.wrappedValue)
        _image = .init(initialValue: nsuiImage)
    }

    var body: some View {
        VStack {
            if image != nil {
                infoSection
            }
            
            HStack {
                Text("tap to select image")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.top)
                Spacer()
            }

            editor
                .onTapGesture {
                    isPresentedActionSheet = true
                }
                .onChange(of: image) { newValue in
                    imageChanged(newValue)
                }
        }
        .sheet(item: $sourceTypeOfPicker) { type in
            ImagePicker(sourceType: type.type, selectedImage: $image)
        }
        .actionSheet(isPresented: $isPresentedActionSheet) {
            actionSheet
        }
        .fileImporter(
            isPresented: $isPresentedFileImporter,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            if case let .success(urls) = result,
               let url = urls.first,
               url.startAccessingSecurityScopedResource() {
                image = NSUIImage(contentsOfFile: url.path)
            }
        }
    }

    @ViewBuilder
    var infoSection: some View {
        if let image {
            VStack(alignment: .leading, spacing: 8) {
                let size = """
                width: \(String(format: "%.1f", image.size.width))
                height: \(String(format: "%.1f", image.size.height))
                """
                HStack {
                    Text(size)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .padding()
            .background(Color.iOS.secondarySystemFill)
            .cornerRadius(8)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var editor: some View {
        if let image {
            Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .padding()
                .border(.black, width: 0.5)
        } else if isOptional {
            Color.iOS.secondarySystemFill
                .overlay(
                    Text("current value is nil")
                        .foregroundColor(.gray)
                )
        } else {
            Text("this type is currently not supported.")
        }
    }

    var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = [
            .default(Text("Photo Library")) {
                sourceTypeOfPicker = .library
            },
            .default(Text("Camera")) {
                sourceTypeOfPicker = .camera
            },
            .default(Text("File")) {
                isPresentedFileImporter = true
            },
            .destructive(Text("Set nil")) {
                image = nil
            },
            .cancel()
        ]

        if !isOptional {
            buttons.remove(at: 3)
        }

        return ActionSheet(
            title: Text("Select source"),
            buttons: buttons
        )
    }
}

extension ImageEditor {
    func imageChanged(_ nsuiImage: NSUIImage?) {
        guard let nsuiImage else {
            setNil()
            return
        }

        switch $value {
        case let v as Binding<NSUIImage>:
            v.wrappedValue = nsuiImage

        case let v as Binding<CIImage>:
            if let ciImage = nsuiImage.ciImage {
                v.wrappedValue = ciImage
            }

        case let v as Binding<CGImage> where Value.self is CGImage.Type:
            if let cgImage = nsuiImage.cgImage {
                v.wrappedValue = cgImage
            }

        case let v as Binding<NSUIImage?>:
            v.wrappedValue = nsuiImage

        case let v as Binding<CIImage?>:
            v.wrappedValue = nsuiImage.ciImage

        case let v as Binding<CGImage?> where Value.self is CGImage?.Type:
            v.wrappedValue = nsuiImage.cgImage

        default:
            break
        }
    }

    func setNil() {
        guard isOptional else { return }

        switch $value {
        case let v as Binding<NSUIImage?>:
            v.wrappedValue = nil
        case let v as Binding<CIImage?>:
            v.wrappedValue = nil
        case let v as Binding<CGImage?>:
            v.wrappedValue = nil
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
