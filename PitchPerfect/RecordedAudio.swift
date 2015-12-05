//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Gareth Hunt on 5/12/2015.
//  Copyright © 2015 ghunt03. All rights reserved.
//

import Foundation
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePath:NSURL, title:String) {
        self.filePathUrl = filePath
        self.title = title
    }
}