//
//  ThirdSignUpViewController.swift
//  CrimeScene
//
//  Created by Jeewoo Yim on 8/26/24.
//

import UIKit
import FirebaseAuth

class ThirdSignUpViewController: UIViewController {
    var user: UserInfo?
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var confirmField: UITextField!

    @IBAction func sendNumber(_ sender: UIButton) {
        guard let phoneNumber = phoneField.text, !phoneNumber.isEmpty else {
            showAlert(message: "휴대폰 번호를 입력해주세요.")
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showAlert(message: "인증번호 전송 도중 오류가 발생했습니다.")
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        guard let verificationCode = confirmField.text, !verificationCode.isEmpty,
              let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            showAlert(message: "인증번호 확인 도중 오류가 발생했습니다.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.showAlert(message: "인증번호 확인 도중 오류가 발생했습니다.")
                return
            }
            self.user?.phoneNum = Int(self.phoneField.text!)
            let fourthVC = FourthSignUpViewController()
            fourthVC.user = self.user
            self.navigationController?.pushViewController(fourthVC, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
