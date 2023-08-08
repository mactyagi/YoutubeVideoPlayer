//
//  NetworkManager.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//

import Foundation

class DownloadService{
    private var task: URLSessionDownloadTask?
    private var session: URLSession?
    private var resumeData: Data?
    
    
    func startDownload(url: String, delegate: URLSessionDownloadDelegate){
        resumeData = nil
        guard let url = URL(string: url) else { return }
        session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
        task = session?.downloadTask(with: url)
        task?.resume()
    }
    
    
    func stopDownload(){
        task?.cancel()
        resumeData = nil
    }
    
    
    func pauseDownload(){
        resumeData = nil
        task?.cancel(byProducingResumeData: { data in
            self.resumeData = data
        })
    }
    
    func resumeDownload(){
        if let resumeData{
            task = session?.downloadTask(withResumeData: resumeData)
            task?.resume()
            self.resumeData = nil
        }
        
    }
}

//class NetworkManager: NSObject{
//    var progressClosure : ((_ prgress: Float, _ error: Error) -> ())?
//    typealias Progress = ((Float) -> ())?
//    func downloadVideo(videoUrlString: String, progress: Progress){
//        self.progressClosure = progress
//        guard let url = URL(string: videoUrlString) else { return }
//
//        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
//        let task = session.downloadTask(with: url) { url, response, error in
//            if let error{
//
//            }
//        }
//        task.resume()
//    }
//    func getListOfVideos(){
//        let url = "https://www.youtube.com/watch?v=IfNB5RTxnhI"
//        let headers = [
//            "X-RapidAPI-Key": "22033b7757msh0e2f86f6fb062c2p1c157fjsn04d53da97b11",
//            "X-RapidAPI-Host": "youtube-to-mp4.p.rapidapi.com"
//        ]
//
//        guard let url = URL(string: url) else { return }
//        var URLRequest = URLRequest(url: url)
//        URLRequest.httpMethod = "GET"
//        URLRequest.allHTTPHeaderFields = headers
//
//        print(URLRequest.url)
//        URLSession.shared.dataTask(with: URLRequest) { data, response, error in
//            if let error{
//                return
//            }
//            if let data = data {
//                data.printJson()
//            }
//        }.resume()
//    }
//}

extension Data {
    func printJson() {
            do {
                let json = try JSONSerialization.jsonObject(with: self, options: [])
                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                guard let jsonString = String(data: data, encoding: .utf8) else {
                    print("Inavlid data")
                    return
                }
                print(jsonString)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
}

