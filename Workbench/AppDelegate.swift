import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let app_name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            UIView.setFullContext([
                "app_name": app_name
            ])
        }

        // codestep-CC68ED86-2CA9-42CB-AA7F-C8C7F4190365 CSV Read Extra.json
        //Strings.loadStringsFromFile(name: "Extra")

        enterStoryboard(name: "LaunchScreen")

        perform(#selector(fadeOutLaunchScreen), with: nil, afterDelay: 0.4)

        return true
    }

    // codestep-7A806A89-162F-44C6-8472-54A7627F0825 Application Open URL
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {

        // codestep-186B9FFD-7B58-4737-83F1-2037D80F0112 App Scheme Config
        // This is the entry point to decode a qr code/app scheme
        // Setup is for "workbench-test" as the App Scheme and parameters
        // are supplied as: workbench-test://set?param1=42&param2=happy

        AppSchemeData.shared.update(url: url)

        if AppSchemeData.shared.lookupBoolBy(name: "open") ?? false {
            window?.rootViewController?.performSegue(withIdentifier: "qrtest", sender: self)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    // ----------------------------------------------------------------------

    func enterStoryboard(name: String, bundle: Bundle? = nil) {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let initialViewController = storyboard.instantiateInitialViewController()
        newWindow.rootViewController = initialViewController
        newWindow.makeKeyAndVisible()
        DispatchQueue.onMain(after: 200) {
            self.window = newWindow
        }
    }

    @objc
    func fadeOutLaunchScreen() {
        UIViewController.prepareFadeScreen()
        enterStoryboard(name: "Main")
    }

}
