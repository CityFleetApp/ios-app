//
//  UIImageBlure.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
    return RBResizeImage(RBSquareImage(image), targetSize: size)
}

func RBSquareImage(image: UIImage) -> UIImage {
    let originalWidth  = image.size.width
    let originalHeight = image.size.height
    
    var edge: CGFloat
    if originalWidth > originalHeight {
        edge = originalHeight
    } else {
        edge = originalWidth
    }
    
    let posX = (originalWidth  - edge) / 2.0
    let posY = (originalHeight - edge) / 2.0
    
    let cropSquare = CGRectMake(posX, posY, edge, edge)
    
    let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
    return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
}

func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

class UIImageManager: NSObject {
    static let GaussianBlur = "CIGaussianBlur"
    static let BarcodeFilter = "CICode128BarcodeGenerator"
    static let FakeColorFilter = "CIFalseColor"
    
    func applyClearBlur(srcImage: UIImage) -> UIImage {
        let contect = CIContext(options: nil)
        
        let inputImage = CIImage(image: srcImage)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        let blurRadius: CGFloat = 10.0
        blurfilter!.setValue(inputImage, forKey: kCIInputImageKey)
        blurfilter!.setValue(blurRadius, forKey: "inputRadius")
        let resultImage = blurfilter!.outputImage //as CIImage
        
        var rect = inputImage?.extent
        rect?.origin.x += blurRadius
        rect?.origin.y += blurRadius
        rect?.size.height -= blurRadius * 2
        rect?.size.width -= blurRadius * 2
        
        let cgImage = contect.createCGImage(resultImage!, fromRect: rect!)
        
        let blurredImage = UIImage(CGImage: cgImage)
        return blurredImage
    }
    
    func blur(scrImage:UIImage) -> UIImage {
        let gaussianBlurFilter = CIFilter(name: UIImageManager.GaussianBlur)
        gaussianBlurFilter?.setDefaults()
        
        let inputImage = CIImage(image: scrImage)
        gaussianBlurFilter?.setValue(inputImage, forKey: kCIInputImageKey)

        gaussianBlurFilter?.setValue(Constant.Image.imageBlurRadius, forKey: kCIInputRadiusKey)
        
        let outputImage = gaussianBlurFilter?.outputImage
        let context = CIContext(options: nil)
        let cgimg = context.createCGImage(outputImage!, fromRect: (inputImage?.extent)!)
        
        let image = UIImage(CGImage: cgimg)
        return image
    }
    
    func generateBarcodeFromString(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSASCIIStringEncoding)
        
        if let filter = CIFilter(name: UIImageManager.BarcodeFilter) {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(2, 4)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return applyFakeColorFilter(output)
            }
        }
        
        return nil
    }
    
    private func applyFakeColorFilter(inputImage: CIImage) -> UIImage? {
        if let filter = CIFilter(name: UIImageManager.FakeColorFilter) {
            filter.setValue(inputImage, forKey: "inputImage")
            filter.setValue(CIColor(color: UIColor.blackColor()), forKey: "inputColor0")
            filter.setValue(CIColor(color: UIColor.clearColor()), forKey: "inputColor1")
            
            if let output = filter.outputImage {
                return UIImage(CIImage: output)
            }
        }
        return nil
    }
}
