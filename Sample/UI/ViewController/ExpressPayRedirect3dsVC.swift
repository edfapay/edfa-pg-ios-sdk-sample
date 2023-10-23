//
//  ExpressPayRedirect3dsVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit
import WebKit

final class ExpressPayRedirect3dsVC: UIViewController {
    
    var termUrl: String
    var termUrl3Ds: String
    var redirectUrl: String
    var paymentRequisites: String

    var completion: ((Bool) -> Void)?
    
    private var webView: WKWebView!
    
    init(termUrl: String,
         termUrl3Ds: String,
         redirectUrl: String,
         paymentRequisites: String) {
        self.termUrl = termUrl
        self.termUrl3Ds = termUrl3Ds
        self.redirectUrl = redirectUrl
        self.paymentRequisites = paymentRequisites
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        navigationItem.setRightBarButton(.init(title: "Close", style: .plain, target: self, action: #selector(closeAction)),
                                         animated: false)
        
        /* Create HTML document with needed redirect values and put them to Webview */
        /* The form is completely invisible and submits data on its own */
        let htmlString = """
        <html>
            <head><title></title></head>
            <body>
                <form method='POST' action='\(redirectUrl)'>
                    <input type='hidden' name='TermUrl' value='\(termUrl)'>
                    <input type='hidden' name='PaReq' value='\(paymentRequisites)'>
                    <input style='display:none;' id='send' type='submit' value='send'>
                </form>
                <script>document.addEventListener('DOMContentLoaded', document.getElementById('send').click());</script>
            </body>
        </html>
        """;
       
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension ExpressPayRedirect3dsVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.request.url?.absoluteString == termUrl3Ds else {
            decisionHandler(.allow)
            return
        }
        
        dismiss(animated: true, completion: nil)
        completion?(true)
        decisionHandler(.cancel)
    }
}
