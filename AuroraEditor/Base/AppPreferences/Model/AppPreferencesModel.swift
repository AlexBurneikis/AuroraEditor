//
//  AppPreferencesModel.swift
//  AuroraEditorModules/AppPreferences
//
//  Created by Lukas Pistrol on 01.04.22.
//

import Foundation
import SwiftUI

/// The Preferences View Model. Accessible via the singleton "``AppPreferencesModel/shared``".
///
/// **Usage:**
/// ```swift
/// @StateObject
/// private var prefs: AppPreferencesModel = .shared
/// ```
public final class AppPreferencesModel: ObservableObject {

    /// The publicly available singleton instance of ``AppPreferencesModel``
    public static let shared: AppPreferencesModel = .init()

    private init() {
        self.preferences = .init()
        self.preferences = loadPreferences()
    }

    /// Published instance of the ``AppPreferences`` model.
    ///
    /// Changes are saved automatically.
    @Published
    public var preferences: AppPreferences {
        didSet {
            try? savePreferences()
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    /// Load and construct ``AppPreferences`` model from
    /// `~/.config/auroraeditor/preferences.json`
    private func loadPreferences() -> AppPreferences {
        if !filemanager.fileExists(atPath: preferencesURL.path) {
            let auroraEditorURL = filemanager
                .homeDirectoryForCurrentUser
                .appendingPathComponent(".config", isDirectory: true)
                .appendingPathComponent("auroraeditor", isDirectory: true)
            try? filemanager.createDirectory(at: auroraEditorURL, withIntermediateDirectories: false)
            return .init()
        }

        guard let json = try? Data(contentsOf: preferencesURL),
              let prefs = try? JSONDecoder().decode(AppPreferences.self, from: json)
        else {
            return .init()
        }
        return prefs
    }

    /// Save``AppPreferences`` model to
    /// `~/.config/auroraeditor/preferences.json`
    private func savePreferences() throws {
        let data = try JSONEncoder().encode(preferences)
        let json = try JSONSerialization.jsonObject(with: data)
        let prettyJSON = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        try prettyJSON.write(to: preferencesURL, options: .atomic)
    }

    /// Default instance of the `FileManager`
    private let filemanager = FileManager.default

    /// The base URL of preferences.
    ///
    /// Points to `~/.config/auroraeditor/`
    internal var baseURL: URL {
        filemanager
            .homeDirectoryForCurrentUser
            .appendingPathComponent(".config", isDirectory: true)
            .appendingPathComponent("auroraeditor", isDirectory: true)
    }

    /// The URL of the `preferences.json` settings file.
    ///
    /// Points to `~/.config/auroraeditor/preferences.json`
    private var preferencesURL: URL {
        baseURL
            .appendingPathComponent("preferences")
            .appendingPathExtension("json")
    }

    public func sourceControlActive() -> Bool {
        return preferences.sourceControl.general.enableSourceControl
    }
}
