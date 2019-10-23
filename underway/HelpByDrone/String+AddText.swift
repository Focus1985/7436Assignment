//
//  String+AddText.swift
//  HelpByDrone
//
//  Created by Focus on 15/10/19.
//  Copyright © 2019 Focus. All rights reserved.
//

extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
