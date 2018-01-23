//
//  ASNetImageManage.swift
//  RefreshCollectionNodeDemo
//
//  Created by ShevaKuilin on 2018/1/23.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import SDWebImage
import AsyncDisplayKit

class ASNetImageManage: NSObject, ASImageDownloaderProtocol, ASImageCacheProtocol {
    
    static let sharedManager = ASNetImageManage()
    
    func downloadImage(with URL: URL, callbackQueue: DispatchQueue, downloadProgress: ASImageDownloaderProgress?, completion: @escaping ASImageDownloaderCompletion) -> Any? {
        weak var weakOperation: SDWebImageOperation?
        let operation = SDWebImageManager.shared().loadImage(with: URL, options: .retryFailed, progress: nil, completed:  { (cachedImage, data, error, type, unknow, url) -> Void in
            if let image = cachedImage {
                callbackQueue.async {
                    completion(image, error, weakOperation)
                }
                return
            }
            completion(nil, error, nil)
        })
        weakOperation = operation
        return operation
    }
    
    func cancelImageDownload(forIdentifier downloadIdentifier: Any) {
        if let downloadIdentifier = downloadIdentifier as? SDWebImageOperation {
            downloadIdentifier.cancel()
        }
    }
    
    func cachedImage(with URL: URL, callbackQueue: DispatchQueue, completion: @escaping ASImageCacherCompletion) {
        SDWebImageManager.shared().cachedImageExists(for: URL ) { (existed) -> Void in
            if existed {
                SDWebImageManager.shared().loadImage(with: URL, options: .retryFailed, progress: nil, completed: { (cachedImage, data, error, type, unknow, url) -> Void in
                    callbackQueue.async {
                        if let image = cachedImage {
                            callbackQueue.async {
                                completion(image)
                            }
                            return
                        }
                        completion(nil)
                    }
                })
            } else {
                callbackQueue.async {
                    completion(nil)
                }
            }
        }
    }
}

