import UIKit
import WebKit

let cookies: [HTTPCookie] = []

func inAppWebView(cookies: [HTTPCookie] = [], completion: @escaping ((WKWebView)->Void)) {
    
    let contentController = WKUserContentController()
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = contentController
    
    let dataStore = WKWebsiteDataStore.nonPersistent()
    
    let waitGroup = DispatchGroup()
    if #available(iOS 11.0, *) {
        cookies.forEach { (cookie) in
            print("Cookie: \(cookie)")
            waitGroup.enter()
            dataStore.httpCookieStore.setCookie(cookie, completionHandler: {
                waitGroup.leave()
                print("Cookie has been set")
            })
        }
    }
    
    waitGroup.notify(queue: DispatchQueue.main) {
        configuration.websiteDataStore = dataStore
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        completion(webView)
    }
}
