//
//  Extension+.swift
//  Whisper
//
//  Created by 김병철 on 2023/04/11.
//

import SwiftUI

extension UIView {
    // This is the function to convert UIView to UIImage
    public var asUIImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIApplication {
    var activeScene: UIWindowScene? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first {
                .foregroundActive == $0.activationState
            }
    }

    var activeWindow: UIWindow? {
        activeScene?.windows.first(where:\.isKeyWindow)
    }
}
