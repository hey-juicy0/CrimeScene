//
//  SecondSignUpViewController.swift
//  CrimeScene
//
//  Created by Jeewoo Yim on 8/26/24.
//

import UIKit
import FirebaseAuth


class SecondSignUpViewController: UIViewController {
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var pwConfirmField: UITextField!
    var user: UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // 추가 초기화 작업이 필요할 경우 여기에 추가
    }

    @IBAction func nextButton(_ sender: UIButton) {
        // 비밀번호 유효성 검사 및 일치성 검사 수행
        validatePasswords()
    }
    
    func validatePasswords() {
        // 비밀번호와 비밀번호 확인 필드의 텍스트를 동시에 검사
        guard let password = pwField.text, !password.isEmpty,
              let confirmPassword = pwConfirmField.text, !confirmPassword.isEmpty else {
            showAlert(message: "모두 입력해주세요.")
            return
        }
        
        // 비밀번호 유효성 검사
        if !isPasswordValid(password) {
            showAlert(message: "영문, 숫자, 특수문자 중 2종류 이상을 조합한 최소 8자리 비밀번호를 설정해주세요.")
            return
        }
        
        // 비밀번호 일치성 검사
        if password != confirmPassword {
            showAlert(message: "일치하지 않습니다. 다시 입력해주세요.")
        } else {
            user?.password = pwConfirmField.text
            let thirdVC = ThirdSignUpViewController()
            thirdVC.user = user
            self.navigationController?.pushViewController(thirdVC, animated: true)
            
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let minPasswordLength = 8
        guard password.count >= minPasswordLength else {
            return false
        }
        
        // 정규 표현식 패턴 정의
        let letterRegEx  = "[A-Za-z]"
        let numberRegEx  = "[0-9]"
        let specialCharRegEx = "[!@#$%^&*(),.?:{}|<>]"
        
        // NSPredicate를 사용하여 패턴 검증
        let letterPredicate = NSPredicate(format:"SELF MATCHES %@", letterRegEx)
        let numberPredicate = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let specialCharPredicate = NSPredicate(format:"SELF MATCHES %@", specialCharRegEx)
        
        // 각 조건 체크
        let hasLetter = letterPredicate.evaluate(with: password)
        let hasNumber = numberPredicate.evaluate(with: password)
        let hasSpecialChar = specialCharPredicate.evaluate(with: password)
        
        // 두 가지 이상의 조건이 충족되는지 확인
        let criteriaCount = [hasLetter, hasNumber, hasSpecialChar].filter { $0 }.count
        return criteriaCount >= 2
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
