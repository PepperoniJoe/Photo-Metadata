//
//  Constants.swift
//  Photo Metadata
//
//  Created by Marcy Vernon on 8/7/20.
//  Copyright © 2020 com.MarcyVernon. All rights reserved.
//

import Foundation

struct K {
    static let photoPolicy = "This app needs permission to access the photo library. Go to Settings > Privacy > Photos > PhotoMetadata."
}

enum Title: String {
    case alert = "Alert"
    case ok    = "OK"
}

enum Error: String {
    case latitude  = "latitude unavailable on this photo"
    case longitude = "longitude unavailable on this photo"
    case data      = "date unavailable on this photo"
}

