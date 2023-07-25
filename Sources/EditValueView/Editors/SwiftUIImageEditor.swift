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

    @Binding var image: Image
    @State var sourceTypeOfPicker: SourceType?
    @State var isPresentedActionSheet = false

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
        }
        .sheet(item: $sourceTypeOfPicker) { type in
            SwiftUIImagePicker(sourceType: type.type, selectedImage: .init($image))
        }
        .actionSheet(isPresented: $isPresentedActionSheet) {
            actionSheet
        }
    }

    var imageView: some View {
        image
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
#endif
