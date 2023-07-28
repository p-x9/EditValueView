//
//  UIImage.swift
//  
//
//  Created by p-x9 on 2023/07/28.
//  
//

#if canImport(UIKit)
import UIKit

extension UIImage {
    func toCIImage() -> CIImage? {
        if let ciImage {
            return ciImage
        } else if let cgImage {
            return CIImage(cgImage: cgImage)
        }
        return nil
    }
}
#endif
