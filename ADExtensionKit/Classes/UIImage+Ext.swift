//
//  UIImage+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/24.
//

import Foundation

extension UIImage: ExtensionCompatible {}

public extension ExtensionWrapper where Base: UIImage {
    
    func base64String() -> String? {
        if let data = base.pngData() {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func roundCorner(radius: CGFloat? = nil, corners: UIRectCorner = .allCorners) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        guard let ctx: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        let r = radius ?? min(base.size.width, base.size.height)/2
        let rect = CGRect(origin: .zero, size: base.size)
        ctx.addPath(UIBezierPath(roundedRect: rect,
                    byRoundingCorners: UIRectCorner.allCorners,
                    cornerRadii: CGSize(width: r, height: r)).cgPath)
        ctx.clip()
        base.draw(in: rect)
        ctx.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
    
    func applyAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setBlendMode(.multiply)
        ctx?.setAlpha(alpha)
        base.draw(at: .zero)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output ?? base
    }
    
    func applyGaussianBlur(radius: CGFloat = 10) -> UIImage? {
        let ciimage = CIImage(image: base)
        let gaussianBlur = CIFilter(name:"CIGaussianBlur")
        gaussianBlur?.setValue(ciimage, forKey: "inputImage")
        gaussianBlur?.setValue(radius, forKey: "inputRadius")
        
        guard let filter = gaussianBlur else { return nil }
        
        let cgimage = UIImage.cicontext.createCGImage((filter.outputImage)!, from: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        
        guard let cg = cgimage else { return nil }
        
        return UIImage(cgImage: cg)
    }
    
    func removeWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking)
    }
    
    func removeBlackBg() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return transparentColor(colorMasking)
    }
    
    func safeJpegData(compressionQuality: CGFloat) -> Data {
        func copy(image: UIImage) -> UIImage {
            UIGraphicsBeginImageContext(image.size);
            image.draw(at: .zero)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return result!
        }
        if let data = base.jpegData(compressionQuality: compressionQuality) {
            return data
        }
        return copy(image: base).jpegData(compressionQuality: compressionQuality)!
    }
    
    private func transparentColor(_ colorMask: [CGFloat]) -> UIImage {
        guard let imageRef = base.cgImage, let maskImageRef = imageRef.copy(maskingColorComponents: colorMask) else {
            return base
        }
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.translateBy(x: 0.0, y: base.size.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        ctx?.draw(maskImageRef, in: CGRect(origin: .zero, size: base.size))
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output ?? base
    }
    
}

public enum ADGradientImageDirection {
    case horizontal
    case vertical
    case leftTop2RightBottom
    case leftBottom2RightTop
    case custom(CGPoint,CGPoint)
    
    public func points() -> (CGPoint,CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
        case .leftTop2RightBottom:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        case .leftBottom2RightTop:
            return (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0))
        case let .custom(s, e):
            return (s, e)
        }
    }
}

public extension ExtensionWrapper where Base: UIImage {
    
    static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            ctx?.setFillColor(color.cgColor)
            ctx?.fill(rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func gradient(_ colors: [UIColor],
                         size: CGSize,
                      direction: ADGradientImageDirection = .horizontal,
                         locations:[CGFloat]? = nil,
                         radius: CGFloat = 0) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return image(color: colors[0])
        }
        if locations != nil {
            assert(colors.count == locations!.count, "The array of locations should should contain the same number of items as `colors'.")
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius)
        path.addClip()
        ctx?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: nil, colors: colors.map{$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let s = CGPoint(x: size.width*direction.points().0.x, y: size.height*direction.points().0.y)
        let e = CGPoint(x: size.width*direction.points().1.x, y: size.height*direction.points().1.y)
        ctx?.drawLinearGradient(gradient, start: s, end: e, options: .drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

public extension ExtensionWrapper where Base: UIImage {
    
    func resize(to size: CGSize, mode: UIView.ContentMode) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let fitRect = rectFitWithContentMode(CGRect(x: 0, y: 0, width: size.width, height: size.height), size: base.size, mode: mode)
        base.draw(in: fitRect)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    private func rectFitWithContentMode(_ rect: CGRect, size: CGSize, mode: UIView.ContentMode) -> CGRect {
        let stdRect = rect.standardized
        let center = CGPoint(x: stdRect.midX, y: stdRect.midY)
        var ret: CGRect = .zero
        switch mode {
        case .scaleAspectFit,.scaleAspectFill:
            var scale: CGFloat = 0
            if mode == .scaleAspectFit {
                if (size.width / size.height < stdRect.size.width / stdRect.size.height) {
                    scale = stdRect.size.height / size.height;
                } else {
                    scale = stdRect.size.width / size.width;
                }
            }else{
                if (size.width / size.height < stdRect.size.width / stdRect.size.height) {
                    scale = stdRect.size.width / size.width;
                } else {
                    scale = stdRect.size.height / size.height;
                }
                ret.size = CGSize(width: size.width * scale, height: size.height * scale)
                ret.origin = CGPoint(x: center.x - ret.size.width * 0.5, y: center.y - ret.size.height * 0.5)
            }
        case .center:
            ret.size = size
            ret.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        case .top:
            ret.size = size
            ret.origin.x = center.x - size.width * 0.5
        case .bottom:
            ret.size = size
            ret.origin = CGPoint(x: center.x - size.width * 0.5, y: rect.size.height - size.height)
        case .left:
            ret.size = size
            ret.origin.y = center.y - size.height * 0.5
        case .right:
            ret.size = size
            ret.origin = CGPoint(x: rect.size.width - size.width, y: center.y - size.height * 0.5)
        case .scaleToFill,.redraw:
            ret = stdRect
        default:
            ret = stdRect
        }
        return ret
    }
    
}

public extension ExtensionWrapper where Base: UIImage {
    
    static func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("UIImageGif: Source for the image does not exist")
            return nil
        }

        return animatedImageWithSource(source)
    }

    static func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("UIImageGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("UIImageGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    static func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
              print("UIImageGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("UIImageGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    @available(iOS 9.0, *)
    static func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("UIImageGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data)
    }

    private static func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    private static func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    private static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = gcdForPair(val, gcd)
        }

        return gcd
    }

    private static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = delayForImageAtIndex(Int(index),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }
    
}

extension UIImage {
    static let cicontext: CIContext = {
        if let device = MTLCreateSystemDefaultDevice() {
            return CIContext(mtlDevice: device)
        }
        return CIContext()
    }()
}
