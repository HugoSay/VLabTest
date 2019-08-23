//
//  Observable+Unwrap.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import RxSwift

extension Observable {
    func unwrap<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
