//
//  AmplifySampleGen2App.swift
//  AmplifySampleGen2
//
//  Created by Wilfred Bradley Tan on 28/6/24.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import SwiftUI

@main
struct AmplifySampleGen2App: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            
            // Used for realtime sync
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
            try Amplify.add(plugin: dataStorePlugin)
            
            try Amplify.configure(with: .amplifyOutputs)
        } catch {
            print("Unable to configure Amplify \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
