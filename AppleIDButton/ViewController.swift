//
//  ViewController.swift
//  AppleIDButton
//
//  Created by الياسي on 02/03/2022.
//

import Firebase
import FirebaseCore
import GoogleSignIn
import UIKit
import AuthenticationServices
class ViewController: UIViewController {
    @IBOutlet weak var informationsLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional presentingViewController after loading the view.
        setupGoogle()
    }
  
    private func setupGoogle(){
    GIDSignIn.sharedInstance()?.presentingViewController=self
    GIDSignIn.sharedInstance()?.delegate = self
    
}
    
 
    @IBAction func signInButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func SignwithAppleButton(_ sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
         let controller = ASAuthorizationController(authorizationRequests:[request])
            controller.delegate = self
             controller.presentationContextProvider = self
            controller.performRequests()
    }
    
}

extension ViewController:ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding  {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("failed!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization
    authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let id = credentials.user
            let email = credentials.email
            let firstName = credentials.fullName?.givenName
             let lastName = credentials.fullName?.familyName
            informationsLabel.text = "Account holder name: \(lastName ?? "") \n email : \(email ?? "") \n ID: \(id)"
            print( 1,"id:",id )
            print(2,"email:",lastName ?? "")
            print(3,"firstName:",firstName ?? "")
            print(4,"lastName:",email ?? "")
 
            break
        default:
            print("email"  )
        break
        }
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
extension ViewController:GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
        print ("Error because \(error.localizedDescription)")
        }
        guard let auth = user.authentication else {return}
        print(1,auth.clientID ?? "")
        print(2,auth.idToken ?? "")
        print(auth.refreshToken ?? "")
//        let credentails  = GoogleAuthProvider.credential(withIDToken:  auth.idToken, accessToken: auth.clientID)
//        //GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToker
//        Auth.auth().signIn(with: credentails) { (authResult, error) in
//        if let error = error{
//        print ("Error because \(error.localizedDescription)")
//        return
//        }
//        print ("Successful Sign in to our firebasel")
//    }
                                                         }
    
}
