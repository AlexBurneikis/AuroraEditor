//
//  FileItem+Array.swift
//  AuroraEditorModules/WorkspaceClient
//
//  Created by Lukas Pistrol on 17.03.22.
//

import Foundation

public extension Array where Element == WorkspaceClient.FileItem {

    /// Sorts the elements in alphabetical order.
    /// - Parameter foldersOnTop: if set to `true` folders will always be on top of files.
    /// - Returns: A sorted array of ``WorkspaceClient/WorkspaceClient/FileItem``
    func sortItems(foldersOnTop: Bool) -> Self {
        var alphabetically = sorted { $0.fileName < $1.fileName }

        if foldersOnTop {
            var foldersOnTop = alphabetically.filter { $0.children != nil }
            alphabetically.removeAll { $0.children != nil }

            foldersOnTop.append(contentsOf: alphabetically)

            return foldersOnTop
        } else {
            return alphabetically
        }
    }
}

public extension Array where Element: Hashable {

    // Checks the difference between two given items.
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
