//
//  LoginViewController.swift
//  CrimeScene
//
//  Created by Jeewoo Yim on 8/26/24.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitLogin(_ sender: UIButton) {
        guard let email = emailField.text, let password = pwField.text else{
            showAlert(message: "이메일과 비밀번호를 입력해주세요.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult != nil{
                self.navigateToMain()
            }
            
        }
    }
    func navigateToMain() {
        
        UserDefaults.standard.set(true, forKey: "loggedIn")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController {
                // 루트 ViewController를 MainViewController로 설정합니다.
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                mainNavigationController.setViewControllers([mainViewController], animated: false)
                
                // 현재 ViewController를 제외하고 새로운 Navigation Controller를 설정합니다.
                UIApplication.shared.windows.first?.rootViewController = mainNavigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
