//
//  SequenceType+Extension.swift
//  MK
//
//  Created by MK on 16/7/10.
//  Copyright © 2016年 MK. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}

extension Array {
    
    // web link: http://swiftrien.blogspot.hk/2015/02/array-is-missing-removeobject.html
    mutating func removeObject<U: AnyObject>(_ object: U) -> Element? {
        if count > 0 {
            for index in startIndex ..< endIndex {
                if (self[index] as! U) === object { return self.remove(at: index) }
            }
        }
        return nil
    }
}

