//
//  CachedImageView.swift
//  GithubProfiles
//
//  Created by Sharon Omoyeni Babatunde on 01/01/2025.
//

import UIKit

public final class CachedImageView: UIImageView {
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let imageCacheDirectory: URL
    
    override init(frame: CGRect = .zero) {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.imageCacheDirectory = cacheDirectory.appendingPathComponent("ImageCache")
        super.init(frame: frame)
        createCacheDirectoryIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.imageCacheDirectory = cacheDirectory.appendingPathComponent("ImageCache")
        super.init(coder: coder)
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: imageCacheDirectory.path) else { return }
        try? fileManager.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true)
    }
    
    private func getCachedImageFilePath(for url: String) -> URL {
        let fileName = "\(url.hashValue).image"
        return imageCacheDirectory.appendingPathComponent(fileName)
    }
    
    func fetchImage(with url: String) {
        let urlString = url
        if let cachedImage = memoryCache.object(forKey: NSString(string: url)) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
            return
        }
        let imageFilePath = getCachedImageFilePath(for: url)
        if fileManager.fileExists(atPath: imageFilePath.path),
           let imageData = try? Data(contentsOf: imageFilePath),
           let diskCachedImage = UIImage(data: imageData) {
            DispatchQueue.main.async { [weak self] in
                self?.image = diskCachedImage
                // Also cache in memory for faster access next time
                self?.memoryCache.setObject(diskCachedImage, forKey: NSString(string: urlString))
            }
            return
        }
        
        guard let url = URL(string: urlString) else {
            Logger.printIfDebug(data: "unable to get image url", logType: .error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                Logger.printIfDebug(data: "\(error): , \(error.localizedDescription) found in cachedImage", logType: .error)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Save to disk cache
                try? data.write(to: imageFilePath)
                
                DispatchQueue.main.async {
                    self.image = image
                    // Save to memory cache
                    self.memoryCache.setObject(image, forKey: NSString(string: urlString))
                }
            }
        }
        task.resume()
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: imageCacheDirectory)
        createCacheDirectoryIfNeeded()
    }
}

extension CachedImageView {
    func configureCacheLimits(memoryLimit: Int = 100, countLimit: Int = 100) {
        memoryCache.totalCostLimit = memoryLimit * 1024 * 1024  // Convert to MB
        memoryCache.countLimit = countLimit
    }
}
