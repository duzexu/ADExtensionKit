//
//  UIImageView+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/29.
//

import UIKit

public extension ExtensionWrapper where Base: UIImageView {
    
    func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.ext.gif(name: name)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.ext.gif(asset: asset)
            DispatchQueue.main.async {
                self.base.image = image
            }
        }
    }
}
