//
//  AuroraEditorWindowController.swift
//  AuroraEditor
//
//  Created by Pavel Kasila on 18.03.22.
//

import Cocoa
import SwiftUI

// swiftlint:disable:next type_body_length
final class AuroraEditorWindowController: NSWindowController, NSToolbarDelegate {

    private var prefs: AppPreferencesModel = .shared

    var workspace: WorkspaceDocument?
    var quickOpenPanel: OverlayPanel?

    private var splitViewController: NSSplitViewController! {
        get { contentViewController as? NSSplitViewController }
        set { contentViewController = newValue }
    }

    init(window: NSWindow, workspace: WorkspaceDocument) {
        self.workspace = workspace
        super.init(window: window)

        setupSplitView(with: workspace)
        setupToolbar()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSplitView(with workspace: WorkspaceDocument) {
        let splitVC = NSSplitViewController()

        let navigatorView = NavigatorSidebar(workspace: workspace, windowController: self)
        let navigator = NSSplitViewItem(
            sidebarWithViewController: NSHostingController(rootView: navigatorView)
        )
        navigator.titlebarSeparatorStyle = .none
        navigator.minimumThickness = 260
        navigator.collapseBehavior = .useConstraints
        splitVC.addSplitViewItem(navigator)

        let workspaceView = WorkspaceView(windowController: self, workspace: workspace)
        let mainContent = NSSplitViewItem(
            viewController: NSHostingController(rootView: workspaceView)
        )
        mainContent.titlebarSeparatorStyle = .line
        splitVC.addSplitViewItem(mainContent)

        let inspectorView = InspectorSidebar(workspace: workspace, windowController: self)
        let inspector = NSSplitViewItem(
            viewController: NSHostingController(rootView: inspectorView)
        )
        inspector.titlebarSeparatorStyle = .line
        inspector.minimumThickness = 260
        inspector.isCollapsed = true
        inspector.collapseBehavior = .useConstraints
        splitVC.addSplitViewItem(inspector)

        self.splitViewController = splitVC
    }

    private func setupToolbar() {
        let toolbar = NSToolbar(identifier: UUID().uuidString)
        toolbar.delegate = self
        toolbar.displayMode = .labelOnly
        toolbar.showsBaselineSeparator = false
        self.window?.titleVisibility = .hidden
        self.window?.toolbarStyle = .unifiedCompact
        if prefs.preferences.general.tabBarStyle == .native {
            // Set titlebar background as transparent by default in order to
            // style the toolbar background in native tab bar style.
            self.window?.titlebarAppearsTransparent = true
            self.window?.titlebarSeparatorStyle = .none
        } else {
            // In xcode tab bar style, we use default toolbar background with
            // line separator.
            self.window?.titlebarAppearsTransparent = false
            self.window?.titlebarSeparatorStyle = .automatic
        }
        self.window?.toolbar = toolbar
    }

    // MARK: - Toolbar

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleFirstSidebarItem,
            .flexibleSpace,
            .runApplication,
            .sidebarTrackingSeparator,
            .branchPicker,
            .flexibleSpace,
            .toolbarAppInformation,
            .flexibleSpace,
            .libraryPopup,
            .toggleLastSidebarItem
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleFirstSidebarItem,
            .flexibleSpace,
            .runApplication,
            .sidebarTrackingSeparator,
            .branchPicker,
            .flexibleSpace,
            .toolbarAppInformation,
            .flexibleSpace,
            .libraryPopup,
            .itemListTrackingSeparator,
            .toggleLastSidebarItem
        ]
    }

    // swiftlint:disable:next function_body_length
    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case .itemListTrackingSeparator:
                guard let splitViewController = splitViewController else {
                    return nil
                }

                return NSTrackingSeparatorToolbarItem(
                    identifier: NSToolbarItem.Identifier.itemListTrackingSeparator,
                    splitView: splitViewController.splitView,
                    dividerIndex: 1
                )
        case .toggleFirstSidebarItem:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleFirstSidebarItem)
            toolbarItem.label = "Navigator Sidebar"
            toolbarItem.paletteLabel = "Navigator Sidebar"
            toolbarItem.toolTip = "Hide or show the Navigator"
            toolbarItem.isBordered = true
            toolbarItem.target = self
            toolbarItem.action = #selector(self.toggleFirstPanel)
            toolbarItem.image = NSImage(
                systemSymbolName: "sidebar.leading",
                accessibilityDescription: nil
            )?.withSymbolConfiguration(.init(scale: .large))

            return toolbarItem
        case .runApplication:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.runApplication)
            toolbarItem.label = "Run Application"
            toolbarItem.paletteLabel = "Run Application"
            toolbarItem.toolTip = "Start the active scheme"
            toolbarItem.isEnabled = false
            toolbarItem.target = self
            toolbarItem.image = NSImage(systemSymbolName: "play.fill",
                                        accessibilityDescription: nil)?.withSymbolConfiguration(.init(scale: .small))

            return toolbarItem
        case .toolbarAppInformation:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toolbarAppInformation)
            let view = NSHostingView(
                rootView: ToolbarAppInfo()
            )
            toolbarItem.view = view

            return toolbarItem
        case .toggleLastSidebarItem:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleLastSidebarItem)
            toolbarItem.label = "Inspector Sidebar"
            toolbarItem.paletteLabel = "Inspector Sidebar"
            toolbarItem.toolTip = "Hide or show the Inspectors"
            toolbarItem.isBordered = true
            toolbarItem.target = self
            toolbarItem.action = #selector(self.toggleLastPanel)
            toolbarItem.image = NSImage(
                systemSymbolName: "sidebar.trailing",
                accessibilityDescription: nil
            )?.withSymbolConfiguration(.init(scale: .large))

            return toolbarItem
        case .branchPicker:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.branchPicker)
            let view = NSHostingView(
                rootView: ToolbarBranchPicker(
                    shellClient: sharedShellClient.shellClient,
                    workspace: workspace?.workspaceClient
                )
            )
            toolbarItem.view = view

            return toolbarItem
        case .libraryPopup:
            let toolbarItem = NSToolbarItem(
                itemIdentifier: NSToolbarItem.Identifier.libraryPopup
            )
            toolbarItem.label = "Library"
            toolbarItem.paletteLabel = "Library"
            toolbarItem.toolTip = "Library"
            toolbarItem.isEnabled = false
            toolbarItem.target = self
            toolbarItem.image = NSImage(
                systemSymbolName: "plus",
                accessibilityDescription: nil
            )?.withSymbolConfiguration(
                .init(scale: .small)
            )

            return toolbarItem
        default:
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @objc func toggleFirstPanel() {
        guard let firstSplitView = splitViewController.splitViewItems.first else { return }
        firstSplitView.animator().isCollapsed.toggle()
    }

    @objc func toggleLastPanel() {
        guard let lastSplitView = splitViewController.splitViewItems.last else { return }
        lastSplitView.animator().isCollapsed.toggle()
        if lastSplitView.isCollapsed {
            window?.toolbar?.removeItem(at: (window?.toolbar?.items.count)! - 2)
            window?.toolbar?.removeItem(at: (window?.toolbar?.items.count)! - 2)
        } else {
            window?.toolbar?.insertItem(withItemIdentifier: NSToolbarItem.Identifier.itemListTrackingSeparator,
                                        at: (window?.toolbar?.items.count)! - 1)
            window?.toolbar?.insertItem(withItemIdentifier: NSToolbarItem.Identifier.flexibleSpace,
                                        at: (window?.toolbar?.items.count)! - 1)
        }
    }

    private func getSelectedCodeFile() -> CodeFileDocument? {
        guard let id = workspace?.selectionState.selectedId else { return nil }
        guard let item = workspace?.selectionState.openFileItems.first(where: { item in
            item.tabID == id
        }) else { return nil }
        guard let file = workspace?.selectionState.openedCodeFiles[item] else { return nil }
        return file
    }

    // TODO: Make this more reliable
    @IBAction func saveDocument(_ sender: Any) {
        guard let file = getSelectedCodeFile() else {
            fatalError("Cannot get file")
        }

//        file.save(sender)
        file.saveFileDocument()

        workspace?.convertTemporaryTab()
    }

    @IBAction func openQuickly(_ sender: Any) {
        if let workspace = workspace, let state = workspace.quickOpenState {
            if let quickOpenPanel = quickOpenPanel {
                if quickOpenPanel.isKeyWindow {
                    quickOpenPanel.close()
                    return
                } else {
                    window?.addChildWindow(quickOpenPanel, ordered: .above)
                    quickOpenPanel.makeKeyAndOrderFront(self)
                }
            } else {
                let panel = OverlayPanel()
                self.quickOpenPanel = panel
                let contentView = QuickOpenView(
                    state: state,
                    onClose: { panel.close() },
                    openFile: workspace.openTab(item:)
                )
                panel.contentView = NSHostingView(rootView: contentView)
                window?.addChildWindow(panel, ordered: .above)
                panel.makeKeyAndOrderFront(self)
            }
        }
    }

    // MARK: Git Main Menu Items

    @IBAction func stashChangesItems(_ sender: Any) {
        if tryFocusWindow(of: StashChangesSheet.self) { return }
        if (workspace?.workspaceClient?.model?.changed ?? []).isEmpty {
            let alert = NSAlert()
            alert.alertStyle = .informational
            alert.messageText = "Cannot Stash Changes"
            alert.informativeText = "There are no uncommitted changes in the working copies for this project."
            alert.addButton(withTitle: "OK")
            alert.runModal()
        } else {
            StashChangesSheet(workspaceURL: (workspace?.fileURL!)!).showWindow()
        }
    }

    @IBAction func discardProjectChanges(_ sender: Any) {
        if (workspace?.workspaceClient?.model?.changed ?? []).isEmpty {
            let alert = NSAlert()
            alert.alertStyle = .informational
            alert.messageText = "Cannot Discard Changes"
            alert.informativeText = "There are no uncommitted changes in the working copies for this project."
            alert.addButton(withTitle: "OK")
            alert.runModal()
        } else {
            workspace?.workspaceClient?.model?.discardProjectChanges()
        }
    }

    /// Tries to focus a window with specified view content type.
    /// - Parameter type: The type of viewContent which hosted in a window to be focused.
    /// - Returns: `true` if window exist and focused, oterwise - `false`
    private func tryFocusWindow<T: View>(of type: T.Type) -> Bool {
        guard let window = NSApp.windows.filter({ ($0.contentView as? NSHostingView<T>) != nil }).first
        else { return false }

        window.makeKeyAndOrderFront(self)
        return true
    }
}

private extension NSToolbarItem.Identifier {
    static let toggleFirstSidebarItem = NSToolbarItem.Identifier("ToggleFirstSidebarItem")
    static let toggleLastSidebarItem = NSToolbarItem.Identifier("ToggleLastSidebarItem")
    static let itemListTrackingSeparator = NSToolbarItem.Identifier("ItemListTrackingSeparator")
    static let branchPicker = NSToolbarItem.Identifier("BranchPicker")
    static let libraryPopup = NSToolbarItem.Identifier("LibraryPopup")
    static let runApplication = NSToolbarItem.Identifier("RunApplication")
    static let toolbarAppInformation = NSToolbarItem.Identifier("ToolbarAppInformation")
}
