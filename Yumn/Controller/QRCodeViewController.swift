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
        
        
       // guard let qrURLImage = URL(string: "http://pramodkumar.tk")?.qrImage(using: UIColor.cyan, logo: UIImage(named: "logo3")) else { return }

       // qrImage.image = qrURLImage

        qrImage.image = generateQRCode(from: "hi")
       
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            guard let QRImage = QRFilter.outputImage else {return nil}
            return UIImage(ciImage: QRImage)
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    private func updateColor(image: CIImage) -> CIImage? {
            guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
            
            colorFilter.setValue(image, forKey: kCIInputImageKey)
        colorFilter.setValue(UIColor.green, forKey: "inputColor0")
        colorFilter.setValue(UIColor.white, forKey: "inputColor1")
            return colorFilter.outputImage
        }
    
    private func addLogo(image: CIImage, logo: UIImage) -> CIImage? {
            
            guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
            guard let logo = logo.cgImage else {
                return image
            }
            
            let ciLogo = CIImage(cgImage: logo)

            
            let centerTransform = CGAffineTransform(translationX: image.extent.midX - (ciLogo.extent.size.width / 2), y: image.extent.midY - (ciLogo.extent.size.height / 2))
            
            combinedFilter.setValue(ciLogo.transformed(by: centerTransform), forKey: "inputImage")
            combinedFilter.setValue(image, forKey: "inputBackgroundImage")
            return combinedFilter.outputImage
        }



}


struct QRCodeDataSet {
    let logo: UIImage?
    let url: String
    let backgroundColor: CIColor
    let color: CIColor
    let size: CGSize
    
    init(logo: UIImage? = nil, url: String) {
        self.logo = logo
        self.url = url
        self.backgroundColor = CIColor(red: 1,green: 1,blue: 1)
        self.color = CIColor(red: 1,green: 0.46,blue: 0.46)
        self.size = CGSize(width: 300, height: 300)
    }

    init(logo: UIImage? = nil, url: String, backgroundColor: CIColor, color: CIColor, size: CGSize) {
        self.logo = logo
        self.url = url
        self.backgroundColor = backgroundColor
        self.color = color
        self.size = size
    }
}


extension URL {

   /// Creates a QR code for the current URL in the given color.
   func qrImage(using color: UIColor, logo: UIImage? = nil) -> UIImage? {

      guard let tintedQRImage = qrImage?.tinted(using: color) else {
         return nil
      }

      guard let logo = logo?.cgImage else {
         return UIImage(ciImage: tintedQRImage)
      }

      guard let final = tintedQRImage.combined(with: CIImage(cgImage: logo)) else {
        return UIImage(ciImage: tintedQRImage)
      }

    return UIImage(ciImage: final)
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
  func tinted(using color: UIColor) -> CIImage? {
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

extension CIImage {

  /// Combines the current image with the given image centered.
  func combined(with image: CIImage) -> CIImage? {
    guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
    let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
    combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
    combinedFilter.setValue(self, forKey: "inputBackgroundImage")
    return combinedFilter.outputImage!
  }
}
