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
    var data: [[String]]
    var onPDFGenerated: (Result<URL, Error>) -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let filePath = Bundle.main.path(forResource: htmlName, ofType: "html"),
           let htmlString = try? String(contentsOfFile: filePath) {
            webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // This method intentionally left blank.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, data: data)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var data: [[String]]

        init(_ webView: WebView, data: [[String]]) {
            self.parent = webView
            self.data = data
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
            if let jsonString = String(data: jsonData!, encoding: .utf8) {
                let script = "updateTable(\(jsonString));"
                webView.evaluateJavaScript(script, completionHandler: nil)
            }
        }
        
    }
}

struct TripsReportView: View {
    
    var dataArray = [["Item 1", "Item 2"], ["Item 3", "Item 4"]]

    var body: some View {
        VStack {
            Text("Hello")
            WebView(htmlName: "table", data: dataArray, onPDFGenerated: handlePDFGeneration)
        }
    }
    

    private func handlePDFGeneration(result: Result<URL, Error>) {
        switch result {
        case .success(let fileURL):
            print("PDF saved at: \(fileURL)")
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

