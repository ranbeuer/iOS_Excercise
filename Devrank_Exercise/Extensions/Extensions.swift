//
//  File.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 4/10/19.
//  Copyright © 2019 iTexico. All rights reserved.
//

import Foundation

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
