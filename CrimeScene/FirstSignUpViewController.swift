//
//  FirstSignUpViewController.swift
//  CrimeScene
//
//  Created by Jeewoo Yim on 8/26/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


struct UserInfo{
    var email: String?
    var password: String?
    var phoneNum: Int?
    var nickname: String?
}

class FirstSignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if emailField.hasText{
            let userRef = db.collection("userInfo").document("\(emailField.text)")
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.showAlert(message: "이미 가입되어 있는 이메일입니다.")
                } else {
                    let secondVC = SecondSignUpViewController()
                    let user = UserInfo(email: self.emailField.text)
                    secondVC.user = user
                    self.navigationController?.pushViewController(secondVC, animated: true)
                }
            }
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
