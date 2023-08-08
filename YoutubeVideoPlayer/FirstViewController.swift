//
//  ViewController.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
// AIzaSyBcmBzpdGkHTbBP-kFs5r7j8jz5ug1wWzs



import UIKit
import AVKit
class FirstViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    //MARK: - variables
    var videos: [Video] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getVideos()
    }
    
    
    //MARK: - Functions
    
    func getVideos(){
        videos = CoreDataManager().fetchVideo()
    }
    
    private func playVideo(lastPathComponent: String){
        guard let url = CacheManager.shared.getFilePath(lastPathComponent: lastPathComponent) else{
            print("File not exist")
            return
        }
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}


//MARK: - Table View Delegate and DataSource
extension FirstViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(lastPathComponent: videos[indexPath.row].name!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoTableViewCell
        cell.nameLabel.text = videos[indexPath.row].name
        return cell
    }
}

