//
//  ViewController.swift
//  ADExtensionKit
//
//  Created by zexu007@qq.com on 10/28/2021.
//  Copyright (c) 2021 zexu007@qq.com. All rights reserved.
//

import UIKit
import ADExtensionKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var array: Array<Int> = [1,2,4,2,6,5,7,6,42,1234,1,7]
        let new = array.ext.delete(element: 7, repeated: false)
        print(new)
        let color = UIColor(hex: 0xf2f2f9)
        view.backgroundColor = color
        print(FileManager.ext.documentDir)
        let image = UIImage(named: "bg")
        let ret = image?.ext.removeBlackBg()
        let aaa = UIImage.ext.gradient([UIColor(hex: 0x4158D0)!,UIColor(hex: 0xC850C0)!,UIColor(hex: 0xFFCC70)!], size: CGSize(width: 200, height: 200), radius: 10)
        let imageV = UIImageView(image: aaa)
        imageV.center = view.center
        view.addSubview(imageV)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

class ADView: UIView {
    
}
