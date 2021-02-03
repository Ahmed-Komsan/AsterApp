//
//  ImageLoader.swift
//  AsterApp
//
//  Created by Ahmed Komsan on 30/01/2021.
//

import UIKit


class ImageLoader {
    
    private var task: URLSessionDownloadTask?
    private var session = URLSession.shared
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    static public let shared = ImageLoader()
    
    private init(){
       // do nothing
    }
    
    func downloadImage(with imagePath: String, completionHandler: @escaping (UIImage) -> () ) {
        if let cachedImage = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(cachedImage)
            }
        } else {
            guard let imageURL = URL(string: imagePath) else {
                return
            }
            task = session.downloadTask(with: imageURL, completionHandler: { (location, response, error) in
                if let contentUrl = location, let data = try? Data(contentsOf: contentUrl), let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: imagePath as NSString)
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            })
            task?.resume()
        }
    }
    
    func cachedImage(for imagePath: String) -> UIImage? {
        return self.cache.object(forKey: imagePath as NSString)
    }
    
}
