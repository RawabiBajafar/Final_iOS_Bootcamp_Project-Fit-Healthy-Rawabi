//
//  ImageStore.swift
//  The final project-fitness-rawabi bajafar
//
//  Created by روابي باجعفر on 09/06/1443 AH.
//

import Foundation
import UIKit

class ImageStore {
  static  let cache = NSCache<NSString,UIImage>()
  
  
  static  func setImage(_ image: UIImage, forKey key: String) {
    cache.setObject(image, forKey: key as NSString)
    // Create full URL for image
    let url = imageURL(forKey: key)
    // Turn image into JPEG data
    if let data = image.jpegData(compressionQuality: 0.5){
      // Write it to full URL
      try? data.write(to: url)
      
    }
    
  }
  
  
  static func image(forKey key: String) -> UIImage? {
    if let existingImage = cache.object(forKey: key as NSString){
      return existingImage
    }
    let url = imageURL(forKey: key)
    guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
      return nil
    }
    cache.setObject(imageFromDisk, forKey: key as NSString)
    return imageFromDisk
  }
  
  
  static   func deleteImage(forKey key: String) {
    cache.removeObject(forKey: key as NSString)
    
    let url = imageURL(forKey: key)
    do {
      try FileManager.default.removeItem(at: url)
    } catch {
      print("Error removing the image from disk :\(error)")
    }
    
  }
  
  
  static  func imageURL(forKey key: String) -> URL {
    let documentsDirectories =
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent(key)
  }
  
}

