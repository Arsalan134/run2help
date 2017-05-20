//
//  Extensions.swift
//  run2help
//
//  Created by Arsalan Iravani on 08.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withURLString url: String) {
        self.image = nil
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Otherwise fire off a new download
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            // Dowload hit an error so let's return out
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: url! as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
