//
//  String.swift
//  AuroraEditor
//
//  Created by Nanashi Li on 2022/08/04.
//  Copyright © 2022 Aurora Company. All rights reserved.
//

import Foundation
import AppKit

extension String {

    var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }

    var stringByDeletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }

    /**
     Returns a string colored with the specified color.
     - parameter color: The string representation of the color.
     - returns: A string colored with the specified color.
     */
    func withColor(_ color: String?) -> String {
        return ""
    }

    /// Safely returns an offset index in a string.
    /// Use ``safeOffset(_:offsetBy:)`` to default to limiting to the start or end indexes.
    /// - Parameters:
    ///   - idx: The index to start at.
    ///   - offsetBy: The number (of characters) to offset from the first index.
    ///   - limitedBy: An index to limit the offset by.
    /// - Returns: A `String.Index`
    func safeOffset(_ idx: String.Index, offsetBy offset: Int, limitedBy: String.Index) -> String.Index {
        /// This is the odd case this method solves. Swift's
        /// ``String.index(_:offsetBy:limitedBy:)``
        /// will crash if the given index is equal to the offset, and
        /// we try to go outside of the string's limits anyways.
        if idx == limitedBy {
            return limitedBy
        } else if offset < 0 {
            /// If the offset is going backwards, but the limit index
            /// is ahead in the string we return the original index.
            if limitedBy > idx {
                return idx
            }

            //// Return the index offset by the given offset.
            /// If this index is nil we return the limit index.
            return index(idx,
                         offsetBy: offset,
                         limitedBy: limitedBy) ?? limitedBy
        } else if offset > 0 {
            /// If the offset is going forwards, but the limit index
            /// is behind in the string we return the original index.
            if limitedBy < idx {
                return idx
            }

            /// Return the index offset by the given offset.
            /// If this index is nil we return the limit index.
            return index(idx,
                         offsetBy: offset,
                         limitedBy: limitedBy) ?? limitedBy
        } else {
            /// The offset is 0, so we return the limit index.
            return limitedBy
        }
    }

    /// Safely returns an offset index in a string.
    /// This method will default to limiting to the start or end of the string.
    /// See ``safeOffset(_:offsetBy:limitedBy:)`` for custom limit indexes.
    /// - Parameters:
    ///   - idx: The index to start at.
    ///   - offsetBy: The number (of characters) to offset from the first index.
    /// - Returns: A `String.Index`
    func safeOffset(_ idx: String.Index, offsetBy offset: Int) -> String.Index {
        if offset < 0 {
            return safeOffset(idx, offsetBy: offset, limitedBy: self.startIndex)
        } else if offset > 0 {
            return safeOffset(idx, offsetBy: offset, limitedBy: self.endIndex)
        } else {
            /// If the offset is 0 we return the original index.
            return idx
        }
    }

    func escapedWhiteSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "\\ ")
    }

    func index(from: Int) -> Index {
        return self.index(self.startIndex, offsetBy: from)
    }

    func substring(_ toIndex: Int) -> String {
        let index = index(from: toIndex)
        return String(self[..<index])
    }

    /// Get all regex matches within a body of text
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            Log.error("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func abbreviatingWithTildeInPath() -> String {
        (self as NSString).abbreviatingWithTildeInPath
    }
}
