//
//  CIImage+.swift
//  
//
//  Created by p-x9 on 2023/07/28.
//  
//

#if canImport(UIKit)
import UIKit

extension CIImage {
    var uiImage: UIImage? {
        let context = CIContext()
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return .init(cgImage: cgImage)
        }
        return UIImage(ciImage: self)
    }
}
#endif
