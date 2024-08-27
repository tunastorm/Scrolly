//
//  UIImage+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/22/24.
//

import UIKit

extension UIImage {
     /// 배너에 표지 이미지 재사용하기 위해 리사이즈
    func resize(length: CGFloat) -> UIImage {
         let width = self.size.width
         let height = self.size.height
         let resizeLength: CGFloat = length

         var scale = resizeLength / width
//         if height >= width {
//             scale = width <= resizeLength ? 1 : resizeLength / width
//         } else {
//             scale = height <= resizeLength ? 1 :resizeLength / height
//         }

         let newHeight = height * scale
         let newWidth = width * scale
         let size = CGSize(width: newWidth, height: newHeight)
         let render = UIGraphicsImageRenderer(size: size)
         let renderImage = render.image { _ in
             self.draw(in: CGRect(origin: .zero, size: size))
         }
         return renderImage
     }
 }
