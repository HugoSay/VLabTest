//
//  Photo+Extensions.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import RxSwift

extension Photo {
    var thumbnail: Single<UIImage> {
        return Network.image(url: thumbnailURL)
    }
}
