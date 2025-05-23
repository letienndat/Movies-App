//
//  AppDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 06/02/2025.
//

import UIKit
import DBDebugToolkit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        FirebaseApp.configure()
        DBDebugToolkit.setup()
        UINavigationBar.appearance().barStyle = .black
        Thread.sleep(forTimeInterval: 0.5)

        if Auth.isExistCurrentUser() {
            goToScreenHome()
        } else {
            goToScreenLogin()
        }

        return true
    }

    func goToScreenHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBar = storyboard.instantiateInitialViewController() else { return }

        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

    func goToScreenLogin() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let nav = storyboard.instantiateInitialViewController() else { return }

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let googleHandle = GIDSignIn.sharedInstance.handle(url)
        let facebookHandle = ApplicationDelegate.shared.application(app, open: url, options: options)

        return googleHandle || facebookHandle
    }
}
