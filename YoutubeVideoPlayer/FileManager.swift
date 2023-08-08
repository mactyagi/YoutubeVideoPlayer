//
//  FileManager.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//

import Foundation

struct CacheManager{
    static let shared = CacheManager()
    private init(){}
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    
    
    func isFileExist(url: URL) -> Bool{
        let path = localFilePath(for: url).path()
        return FileManager.default.fileExists(atPath: path)
    }
//
    func getFilePath(lastPathComponent: String) -> URL?{
        let url = documentsPath.appendingPathComponent(lastPathComponent)
        return isFileExist(url: url) ? url : nil
    }
    
    func addFilePath(url: URL, location: URL){
        let destinationURL = localFilePath(for: url)
        print(url)
        print(destinationURL)
        print(location)
        print(url.absoluteString)
        print(url.lastPathComponent)
        // 3
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
          try fileManager.copyItem(at: location, to: destinationURL)
            CoreDataManager().addVideo(name: url.lastPathComponent, url: url.absoluteString, path: destinationURL.path)
        } catch let error {
          print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
}
