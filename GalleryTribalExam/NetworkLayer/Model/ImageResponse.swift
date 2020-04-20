//
//  ImageResponse.swift
//  GalleryTribalExam
//
//  Created by Israel Torres Alvarado  (Vendor) on 4/16/20.
//  Copyright © 2020 Israel Torres Alvarado  (Vendor). All rights reserved.
//

import Foundation

struct ImageResponse: ResponseMappable {
    
    var id: String
    var created_at: String
    var updated_at: String
    var promoted_at: String
    var width: Int
    var height: Int
    var color: String
    var description: String
    var alt_description: String
    var urls: ImageURL
    var links: Links
    var likes: Int
    var user: User
    var liked_by_user: Bool
    
    init(map: [String : Any]) {
        id = map.from("id") ?? ""
        created_at = map.from("created_at") ?? ""
        updated_at = map.from("updated_at") ?? ""
        promoted_at = map.from("promoted_at") ?? ""
        width = map.from("width") ?? 0
        height = map.from("height") ?? 0
        color = map.from("color") ?? ""
        description = map.from("description") ?? ""
        alt_description = map.from("alt_description") ?? ""
        urls = map.from("urls") ?? ImageURL(map: [:])
        links = map.from("links") ?? Links(map: [:])
        likes = map.from("likes") ?? 0
        user = map.from("user") ?? User(map: [:])
        liked_by_user = map.from("liked_by_user") ?? false
    }

}

struct ImageURL: ResponseMappable {

    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String

    init(map: [String : Any]) {
        
        raw = map.from("raw") ?? ""
        full = map.from("full") ?? ""
        regular = map.from("regular") ?? ""
        small = map.from("small") ?? ""
        thumb = map.from("thumb") ?? ""
    
    }
    
}

struct Links: ResponseMappable {
   
    var selfi: String
    var html: String
    var download: String
    var download_location: String
   
    init(map: [String : Any]) {
        self.selfi = map.from("self") ?? ""
        self.html = map.from("html") ?? ""
        self.download = map.from("download") ?? ""
        self.download_location = map.from("download_location") ?? ""
    }
    
}

struct User: ResponseMappable {
   
    var id: String
    var updated_at: String
    var username: String
    var name: String
    var first_name: String
    var last_name: String
    var twitter_username: String
    var portfolio_url: String
    var bio: String
    var location: String
    var links: LinksUser
    var profile_image: ProfileImage
    var instagram_username: String
    var total_collections: Int
    var total_likes: Int
    var total_photos: Int
    var accepted_tos: Bool
    
    init(map: [String : Any]) {
        id = map.from("id") ?? ""
        updated_at = map.from("updated_at") ?? ""
        username = map.from("username") ?? ""
        first_name = map.from("first_name") ?? ""
        last_name = map.from("last_name") ?? ""
        name = map.from("name") ?? ""
        twitter_username = map.from("twitter_username") ?? ""
        portfolio_url = map.from("portfolio_url") ?? ""
        bio = map.from("bio") ?? ""
        location = map.from("location") ?? ""
        links = map.from("links") ?? LinksUser(map: [:])
        profile_image = map.from("profile_image") ?? ProfileImage(map: [:])
        instagram_username = map.from("instagram_username") ?? ""
        total_collections = map.from("total_collections") ?? 0
        total_likes = map.from("total_likes") ?? 0
        total_photos = map.from("total_photos") ?? 0
        accepted_tos = map.from("accepted_tos") ?? false
    }
        
}


struct LinksUser: ResponseMappable {

    var selfi: String
    var html: String
    var photos: String
    var likes: String
    var portfolio: String
    var following: String
    var followers: String
        
    init(map: [String : Any]) {
        
        selfi = map.from("self") ?? ""
        html = map.from("html") ?? ""
        photos = map.from("photos") ?? ""
        likes = map.from("likes") ?? ""
        portfolio = map.from("portfolio") ?? ""
        following = map.from("portfolio") ?? ""
        followers = map.from("followers") ?? ""
        
    }
    
}

struct ProfileImage: ResponseMappable {
    
    var small: String
    var medium: String
    var large: String
    
    init(map: [String : Any]) {
        
        small = map.from("small") ?? ""
        medium = map.from("medium") ?? ""
        large = map.from("large") ?? ""
        
    }
}
