//
//  Extensions.swift
//  templeTag
//
//  Created by Phoenix Fisher on 10/21/25.
//

import UIKit

extension UIImage {
    func centerCroppedSquare() -> UIImage {
        let side = min(size.width, size.height)
        let x = (size.width - side) / 2.0
        let y = (size.height - side) / 2.0
        let cropRect = CGRect(x: x, y: y, width: side, height: side)
        
        guard let cg = cgImage?.cropping(to: cropRect * scale) else { return self }
        return UIImage(cgImage: cg, scale: scale, orientation: imageOrientation)
    }
    
    func downsized(maxDimension: CGFloat) -> UIImage {
        let maxCurrent = max(size.width, size.height)
        guard maxCurrent > maxDimension else { return self }
        let scaleRatio = maxDimension / maxCurrent
        let newSize = CGSize(width: size.width * scaleRatio, height: size.height * scaleRatio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

private extension CGRect {
    static func * (a: CGRect, b: CGFloat) -> CGRect {
        CGRect(x: a.origin.x * b, y: a.origin.y * b, width: a.size.width * b, height: a.size.height * b)
    }
}
