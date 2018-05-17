//
//  LoginViewController.swift
//  NetXMS Mobile Console
//
//  Created by Ēriks Jenkēvics on 21/02/2018.
//  Copyright © 2018 Raden Solutions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
   
   @IBOutlet weak var apiUrl: UITextField!
   @IBOutlet weak var login: UITextField!
   @IBOutlet weak var password: UITextField!
   
   override func viewDidLoad() {
        super.viewDidLoad()
      loadCredentialsFromKeyChain()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   func onLoginSuccess(jsonData: [String : Any]?) -> Void
   {
      if let jsonData = jsonData
      {
         Connection.sharedInstance?.sessionDataMap.updateValue(jsonData["session"] as! String, forKey: "sessionId")
         Connection.sharedInstance?.sessionDataMap.updateValue(jsonData["serverVersion"] as! String, forKey: "serverVersion")
         print("Session id: \(Connection.sharedInstance?.sessionDataMap["sessionId"] ?? "Empty")")
         print("Server version: \(Connection.sharedInstance?.sessionDataMap["serverVersion"] ?? "Empty")")
         
         DispatchQueue.main.async
         {
            Connection.sharedInstance?.getAllObjects()
            Connection.sharedInstance?.getAllAlarms()
            Connection.sharedInstance?.startNotificationHandler()
            self.storeCredentialsInKeyChain()
            let mainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! MainNavigationController
            self.present(mainNavigationController, animated: true, completion: nil)
         }
      }
   }
   
   @IBAction func loginButtonPressed()
   {
      if !(apiUrl.text?.isEmpty)! && !(login.text?.isEmpty)! && !(password.text?.isEmpty)!
      {
         Connection.sharedInstance = Connection(login: login.text!, password: password.text!, apiUrl: apiUrl.text!)
         Connection.sharedInstance?.login(onSuccess: onLoginSuccess)
      }
   }
   
   func storeCredentialsInKeyChain()
   {
      if !(apiUrl.text?.isEmpty)! && !(login.text?.isEmpty)! && !(password.text?.isEmpty)!
      {
         KeychainWrapper.standard.set(apiUrl.text!, forKey: "NetXMSApiUrl")
         KeychainWrapper.standard.set(login.text!, forKey: "NetXMSLogin")
         KeychainWrapper.standard.set(password.text!, forKey: "NetXMSPassword")
      }
   }
   
   func loadCredentialsFromKeyChain()
   {
      if let retreivedApiUrl = KeychainWrapper.standard.string(forKey: "NetXMSApiUrl"),
         let retreivedLogin = KeychainWrapper.standard.string(forKey: "NetXMSLogin"),
         let retreivedPassword = KeychainWrapper.standard.string(forKey: "NetXMSPassword")
      {
         self.apiUrl.insertText(retreivedApiUrl)
         self.login.insertText(retreivedLogin)
         self.password.insertText(retreivedPassword)
         
         loginButtonPressed()
      }
   }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
