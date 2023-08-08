//
//  SecondViewController.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//

import UIKit
import AVKit
class SecondViewController: UIViewController{
    
    
    //MARK: - Outlet
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
//    ["https://firebasestorage.googleapis.com/v0/b/basicreels-7137e.appspot.com/o/video1.mp4?alt=media&token=0a9386ae-b6f6-474c-98f5-b2e9bcc24038", "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4"]
    
    //MARK: - variables
    var viewModel = ViewModel()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        observeEvent()
        progressView.setProgress(0, animated: false)
        percentageLabel.text = ""
        viewModel.stopDownloading()
        myTextField.addTarget(self, action: #selector(textfieldDidChange), for: .editingChanged)
    }
    
    
    //MARK: - IBAction
    @IBAction func startStopButtonPressed(_ sender: UIButton) {
        if startStopButton.currentTitle == "Start"{
            self.progressView.setProgress(0, animated: false)
            percentageLabel.text = ""
            if myTextField.text == nil || myTextField.text!.count == 0{
                showAlert(alert: "Please add URL First!")
                return
            }
            viewModel.startDownloading(urlString: myTextField.text!, delegate: self)
            myTextField.text = ""
        }else{
            viewModel.stopDownloading()
        }
    }
    
    @IBAction func pauseResumeButton(_ sender: UIButton) {
        if pauseResumeButton.currentTitle == "Pause"{
            viewModel.pauseDownloading()
        }else{
            viewModel.resumeDownloading()
        }
    }
    
    
    
    //MARK: - Functions
    @objc func textfieldDidChange(){
        if myTextField.text == nil || myTextField.text!.count == 0{
            startStopButton.isHidden = true
        }else{
            startStopButton.isHidden = false
        }
    }
    
    func observeEvent(){
        viewModel.eventHandler = { event in
            DispatchQueue.main.async {
                switch event{
                case .progress(let progress):
                    print(progress)
                case .downloaded:
                    print("downloaded")
                case .downloading:
                    print("downloading")
                case .error(let error):
                    print(error.localizedDescription)
                case .downloadStatus(let status):
                    switch status{
                    case .downloading:
                        self.pauseResumeButton.isHidden = false
                        self.pauseResumeButton.isHidden = false
                        self.startStopButton.setTitle("Stop", for: .normal)
                        self.pauseResumeButton.setTitle("Pause", for: .normal)
                    case .downloaded:
                        self.startStopButton.setTitle("Start", for: .normal)
                        self.pauseResumeButton.isHidden = true
                    case .pause:
                        self.pauseResumeButton.isHidden = false
                        self.pauseResumeButton.isHidden = false
                        self.startStopButton.setTitle("Stop", for: .normal)
                        self.pauseResumeButton.setTitle("Resume", for: .normal)
                    case .stop:
                        self.progressView.setProgress(0, animated: false)
                        self.percentageLabel.text = ""
                        self.pauseResumeButton.isHidden = true
                        self.startStopButton.setTitle("Start", for: .normal)
                    }
                case .showAlert(let str):
                    self.showAlert(alert: str)
                }
            }
            
        }
    }
    
    func showAlert(alert: String, completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: "Alert!", message: alert, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}



//MARK: - Session Download Delegate
extension SecondViewController:  URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.showAlert(alert: "Download Complete!"){
                self.viewModel.currentStatus = .stop
            }
        }
            self.viewModel.currentStatus = .downloaded
            guard let sourceURL = downloadTask.currentRequest?.url else {
              return
            }
            CacheManager.shared.addFilePath(url: sourceURL, location: location)
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
            let percentage = progress * 100
            self.percentageLabel.text = "\(String(format: "%.2f", percentage)) %"
            print(progress)
        }
       
    }
}
