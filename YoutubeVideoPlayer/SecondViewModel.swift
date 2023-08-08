//
//  ViewModel.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//

import Foundation
enum DownloadStatus{
    case downloading
    case downloaded
    case pause
    case stop
}
struct ViewModel{
    var currentStatus = DownloadStatus.stop{
        didSet{
            eventHandler?(.downloadStatus(currentStatus))
        }
    }
    var downloadService = DownloadService()
    var eventHandler: ((_ event: Event) -> Void)?
    
    mutating func stopDownloading(){
        self.currentStatus = .stop
        downloadService.stopDownload()
    }
    
    mutating func pauseDownloading(){
        currentStatus = .pause
        downloadService.pauseDownload()
    }
    
    mutating func resumeDownloading(){
        currentStatus = .downloading
        downloadService.resumeDownload()
    }
    mutating func startDownloading(urlString: String, delegate: URLSessionDownloadDelegate){
        if CacheManager.shared.isFileExist(url: URL(string: urlString)!){
            eventHandler?(.showAlert("File Already Exist"))
        }else{
            currentStatus = .downloading
            downloadService.startDownload(url: urlString, delegate: delegate)
        }
        
    }
}


extension ViewModel{
    enum Event{
        case downloadStatus(DownloadStatus)
        case progress(Float)
        case downloaded
        case downloading
        case error(Error)
        case showAlert(String)
    }
}
