//
//  CoreDataManager.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    
    func addVideo(name: String, url: String, path: String){
        DispatchQueue.main.async {
            guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let entity = Video(context: context)
            entity.name = name
            entity.url = url
            entity.path = path
            do{
                try context.save()
            }catch{
                print("could not save")
            }
        }
        
    }
    
    func fetchVideo() ->[Video]{
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Video>(entityName: "Video")
        do{
            let videos = try context.fetch(fetchRequest)
            return videos
        }catch let error{
            print("Error in fetching Data, \(error)")
        }
        return []
    }
}
