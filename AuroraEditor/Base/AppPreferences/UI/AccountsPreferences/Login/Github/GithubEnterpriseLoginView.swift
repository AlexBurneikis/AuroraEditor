//
//  GithubEnterpriseLoginView.swift
//  AuroraEditorModules/AppPreferences
//
//  Created by Nanashi Li on 2022/04/12.
//

import SwiftUI

struct GithubEnterpriseLoginView: View {

    @State var eneterpriseLink = ""
    @State var accountName = ""
    @State var accountToken = ""

    @Environment(\.openURL) var createToken

    @Binding var dismissDialog: Bool

    @StateObject
    private var prefs: AppPreferencesModel = .shared

    private let keychain = AuroraEditorKeychain()

    var body: some View {
        VStack {
            Text("Sign in to your GitHub account")

            VStack(alignment: .trailing) {
                HStack {
                    Text("Server:")
                    TextField("https://example.com", text: $eneterpriseLink)
                        .frame(width: 300)
                }
                HStack {
                    Text("Account:")
                    TextField("", text: $accountName)
                        .frame(width: 300)
                }
                HStack {
                    Text("Token:")
                    SecureField("Enter your Personal Access Token",
                                text: $accountToken)
                    .frame(width: 300)
                }
            }

            HStack {
                HStack {
                    Button("Create a Token on GitHub Enterprise") {
                        createToken(URL(string: "https://github.com/settings/tokens/new")!)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Button("Cancel") {
                        dismissDialog = false
                    }
                    if accountToken.isEmpty {
                        Button("Sign In") {}
                        .disabled(true)
                    } else {
                        Button("Sign In") {
                            loginGithubEnterprise(gitAccountName: accountName)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }.padding(.top, 10)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .frame(width: 485, height: 190)
    }

    private func loginGithubEnterprise(gitAccountName: String) {
        let gitAccounts = prefs.preferences.accounts.sourceControlAccounts.gitAccount

        let config = GithubTokenConfiguration(accountToken,
                                              url: eneterpriseLink )
        GithubAccount(config).me { response in
            switch response {
            case .success(let user):
                if gitAccounts.contains(where: { $0.id == gitAccountName.lowercased() }) {
                    Log.warning("Account with the username already exists!")
                } else {
                    Log.info(user)
                    prefs.preferences.accounts.sourceControlAccounts.gitAccount.append(
                        SourceControlAccounts(id: gitAccountName.lowercased(),
                                              gitProvider: "GitHub",
                                              gitProviderLink: eneterpriseLink,
                                              gitProviderDescription: "GitHub",
                                              gitAccountName: gitAccountName,
                                              gitAccountEmail: user.email!,
                                              gitAccountUsername: user.login!,
                                              gitAccountImage: user.avatarURL!,
                                              gitCloningProtocol: true,
                                              gitSSHKey: "",
                                              isTokenValid: true))
                    keychain.set(accountToken, forKey: "github_\(accountName)_enterprise")
                    dismissDialog = false
                }
            case .failure(let error):
                Log.error(error)
            }
        }
    }
}
