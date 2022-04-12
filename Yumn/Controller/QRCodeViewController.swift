//
//  QRCodeViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 11/04/2022.
//

import UIKit
import SwiftUI
import Foundation

class QRCodeViewController: UIViewController {
    
    
    @IBOutlet weak var squareGif: UIImageView!
    
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
       
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.4
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 5
        
        backgroundView.layer.cornerRadius = 30
        
        
        squareGif.loadGif(name: "grey")
        
        
      
        //Setting up the QR code
        let logo = UIImage(named: "logo4")!
        let color = UIColor(red:128/250, green:128/250, blue:128/250, alpha:1.00)
        
         guard let qrURLImage = URL(string: "https://www.google.com")?.qrImage(using: color) else { return }
         qrImage.image = UIImage(ciImage: qrURLImage)
         logo.addToCenter(of: qrImage)
       
        
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

    
    
    
    
    
}
    
    
    
 

extension UIImage {
    
    func addToCenter(of superView: UIView, width: CGFloat = 100, height: CGFloat = 30) {
        let overlayImageView = UIImageView(image: self)
        
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .scaleAspectFit
        superView.addSubview(overlayImageView)
        
        let centerXConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: overlayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
        let height = NSLayoutConstraint(item: overlayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 55)
        let centerYConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerXConst, centerYConst])
    }
}

extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
 
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
 
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
 
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
 
    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
 
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
 
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
 
        return filter.outputImage!
    }
}


extension URL {
 
    /// Creates a QR code for the current URL in the given color.
    func qrImage(using color: UIColor) -> CIImage? {
        return qrImage?.tinted(using: color)
    }
 
    /// Returns a black and white QR code for this URL.
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")
 
        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}
