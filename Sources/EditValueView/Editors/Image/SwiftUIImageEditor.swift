//
//  SwiftUIImageEditor.swift
//  
//
//  Created by p-x9 on 2023/07/25.
//  
//

import SwiftUI

#if canImport(UIKit)
struct SwiftUIImageEditor: View {
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

    @Binding var image: Image?
    @State var sourceTypeOfPicker: SourceType?
    @State var isPresentedActionSheet = false
    @State var isPresentedFileImporter = false

    /// A boolean value that indicates whether the type being edited is an Optional type or not
    var isOptional: Bool

    var body: some View {
        VStack {
            HStack {
                Text("tap to select image")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Spacer()
            }

            editor
                .onTapGesture {
                    isPresentedActionSheet = true
                }
                .onDrop(of: [.image], isTargeted: nil, perform: handleDropImage(providers:))
        }
        .sheet(item: $sourceTypeOfPicker) { type in
            SwiftUIImagePicker(sourceType: type.type, selectedImage: $image)
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
               url.startAccessingSecurityScopedResource(),
               let nsuiImage = NSUIImage(contentsOfFile: url.path) {
                image = Image(uiImage: nsuiImage)
            }
        }
    }

    @ViewBuilder
    var editor: some View {
        if let image {
            image
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .padding()
                .border(.black, width: 0.5)
        } else {
            Color.iOS.secondarySystemFill
                .overlay(
                    Text("current value is nil")
                        .foregroundColor(.gray)
                )
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
            buttons.remove(at: buttons.count - 2)
        }

        return ActionSheet(
            title: Text("Select source"),
            buttons: buttons
        )
    }
}

extension SwiftUIImageEditor {
    func handleDropImage(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        provider.loadObject(ofClass: NSUIImage.self) { item, error in
            guard let image = item as? NSUIImage else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: image)
            }
        }

        return true
    }
}

#endif
