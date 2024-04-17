//
//  TripsReportView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 13/04/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var htmlName: String
    var trips: [TripItem]

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let filePath = Bundle.main.path(forResource: htmlName, ofType: "html"),
           let htmlString = try? String(contentsOfFile: filePath) {
            webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self, trips: trips) }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var trips: [TripItem]

        init(_ webView: WebView, trips: [TripItem]) {
            self.parent = webView
            self.trips = trips
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(trips),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                let script = "updateTable(\(jsonString));"
                webView.evaluateJavaScript(script, completionHandler: nil)
            }
        }
        
    }
}

struct TripsReportView: View {
    
    var trips: [TripItem]

    var body: some View {
        VStack {
            Text("Hello")
            WebView(htmlName: "table", trips: trips)
        }
    }

    
}

