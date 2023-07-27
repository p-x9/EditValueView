//
//  SwiftUIImagePicker.swift
//  
//
//  Created by p-x9 on 2023/07/25.
//  
//

#if canImport(UIKit)

import SwiftUI
import UIKit

struct SwiftUIImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @Binding var selectedImage: Image?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<SwiftUIImagePicker>) -> UIViewControllerType {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: SwiftUIImagePicker

        init(_ parent: SwiftUIImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: image)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
#endif
