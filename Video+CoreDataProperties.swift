//
//  Video+CoreDataProperties.swift
//  YoutubeVideoPlayer
//
//  Created by Manu on 07/08/23.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var path: String?

}

extension Video : Identifiable {

}
