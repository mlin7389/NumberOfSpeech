//
//  String.swift
//  語言數字聽力
//
//  Created by user on 2022/3/13.
//

import Foundation

extension String {
    private func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(fromIndex sIndex:Int, getLength length:Int) -> String {
        let r = sIndex..<sIndex+length
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
