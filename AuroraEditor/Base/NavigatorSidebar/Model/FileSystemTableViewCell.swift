//
//  FileSystemOutlineView.swift
//  AuroraEditor
//
//  Created by TAY KAI QUAN on 14/8/22.
//  Copyright © 2022 Aurora Company. All rights reserved.
//

import SwiftUI

class FileSystemTableViewCell: StandardTableViewCell {

    var fileItem: WorkspaceClient.FileItem!

    var changeLabelLargeWidth: NSLayoutConstraint!
    var changeLabelSmallWidth: NSLayoutConstraint!

    private let prefs = AppPreferencesModel.shared.preferences.general

    /// Initializes the `OutlineTableViewCell` with an `icon` and `label`
    /// Both the icon and label will be colored, and sized based on the user's preferences.
    /// - Parameters:
    ///   - frameRect: The frame of the cell.
    ///   - item: The file item the cell represents.
    ///   - isEditable: Set to true if the user should be able to edit the file name.
    init(frame frameRect: NSRect, item: WorkspaceClient.FileItem?, isEditable: Bool = true) {
        super.init(frame: frameRect, isEditable: isEditable)

        if let item = item {
            addIcon(item: item)
        }
        addModel()
    }

    override func configLabel(label: NSTextField, isEditable: Bool) {
        super.configLabel(label: label, isEditable: isEditable)
        label.delegate = self
    }

    func addIcon(item: FileItem) {
        var imageName = item.systemImage
        if item.watcherCode == nil {
            imageName = "exclamationmark.arrow.triangle.2.circlepath"
        }
        if item.watcher == nil && !item.activateWatcher() {
            // watcher failed to activate
            imageName = "eye.trianglebadge.exclamationmark"
        }
        let image = NSImage(systemSymbolName: imageName, accessibilityDescription: nil)!
        fileItem = item
        icon.image = image
        icon.contentTintColor = color(for: item)
        toolTip = item.fileName
        label.stringValue = label(for: item)
    }

    func addModel() {
        secondaryLabel.stringValue = fileItem.gitStatus?.description ?? ""
        if secondaryLabel.stringValue == "?" { secondaryLabel.stringValue = "A" }
        secondaryLabelIsSmall = secondaryLabel.stringValue.isEmpty
    }

    /// *Not Implemented*
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        fatalError("""
            init(frame: ) isn't implemented on `OutlineTableViewCell`.
            Please use `.init(frame: NSRect, item: WorkspaceClient.FileItem?)
            """)
    }

    /// *Not Implemented*
    required init?(coder: NSCoder) {
        fatalError("""
            init?(coder: NSCoder) isn't implemented on `OutlineTableViewCell`.
            Please use `.init(frame: NSRect, item: WorkspaceClient.FileItem?)
            """)
    }

    /// Returns the font size for the current row height. Defaults to `13.0`
    private var fontSize: Double {
        switch self.frame.height {
        case 20: return 11
        case 22: return 13
        case 24: return 14
        default: return 13
        }
    }

    /// Generates a string based on user's file name preferences.
    /// - Parameter item: The FileItem to generate the name for.
    /// - Returns: A `String` with the name to display.
    func label(for item: WorkspaceClient.FileItem) -> String {
        switch prefs.fileExtensionsVisibility {
        case .hideAll:
            return item.fileName(typeHidden: true)
        case .showAll:
            return item.fileName(typeHidden: false)
        case .showOnly:
            return item.fileName(typeHidden: !prefs.shownFileExtensions.extensions.contains(item.fileType.rawValue))
        case .hideOnly:
            return item.fileName(typeHidden: prefs.hiddenFileExtensions.extensions.contains(item.fileType.rawValue))
        }
    }

    /// Get the appropriate color for the items icon depending on the users preferences.
    /// - Parameter item: The `FileItem` to get the color for
    /// - Returns: A `NSColor` for the given `FileItem`.
    func color(for item: WorkspaceClient.FileItem) -> NSColor {
        if item.children == nil && prefs.fileIconStyle == .color {
            return NSColor(item.iconColor)
        } else {
            return .secondaryLabelColor
        }
    }
}

let errorRed = NSColor.init(red: 1, green: 0, blue: 0, alpha: 0.2)
extension FileSystemTableViewCell: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        label.backgroundColor = validateFileName(for: label?.stringValue ?? "") ? .none : errorRed
    }
    func controlTextDidEndEditing(_ obj: Notification) {
        label.backgroundColor = validateFileName(for: label?.stringValue ?? "") ? .none : errorRed
        if validateFileName(for: label?.stringValue ?? "") {
            fileItem.move(to: fileItem.url.deletingLastPathComponent()
                .appendingPathComponent(label?.stringValue ?? ""))
        } else {
            label?.stringValue = fileItem.fileName
        }
    }

    func validateFileName(for newName: String) -> Bool {
        guard newName != fileItem.fileName else { return true }

        guard !newName.isEmpty && newName.isValidFilename &&
              !WorkspaceClient.FileItem.fileManger.fileExists(atPath:
                    fileItem.url.deletingLastPathComponent().appendingPathComponent(newName).path)
        else { return false }

        return true
    }
}

extension String {
    var isValidFilename: Bool {
        let regex = "[^:]"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return !testString.evaluate(with: self)
    }
}
