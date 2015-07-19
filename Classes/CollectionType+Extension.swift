//
//  CollectionType+Extension.swift
//  Pods
//
//  Created by Gilad Gurantz on 7/18/15.
//
//

import Foundation

extension CollectionType {
    func mapFilterNil<T>(@noescape transform: (Self.Generator.Element) -> T?) -> [T] {
        return self.map(transform).filter{ $0 != nil }.map{ $0! }
    }
}