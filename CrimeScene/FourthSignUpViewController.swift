//
//  FourthSignUpViewController.swift
//  CrimeScene
//
//  Created by Jeewoo Yim on 8/27/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class FourthSignUpViewController: UIViewController {
    var user: UserInfo?
    let db = Firestore.firestore()

    @IBOutlet weak var nicknameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        guard let nickname = nicknameField.text, !nickname.isEmpty else {
            showAlert(message: "닉네임을 입력하세요.")
            return
        }
        
        if validation(nickname){
            showAlert(message: "특수문자 사용이 불가합니다.")
        }
        
        let userInfoRef = db.collection("userInfo")
        userInfoRef.whereField("nickname", isEqualTo: nickname).getDocuments { (querySnapshot, error) in
            if let error = error {
                self.showAlert(message: "오류가 발생했습니다. 다시 시도해주세요.")
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                self.showAlert(message: "이미 존재하는 닉네임입니다.")
            } else {
                self.user?.nickname = nickname
                // 1. Firebase Authentication에 사용자 등록
                Auth.auth().createUser(withEmail: self.user!.email!, password: self.user!.password!) { authResult, error in
                     if let error = error {
                         self.showAlert(message: "회원 가입 도중 오류가 발생했습니다. 다시 시도해주세요.")
                         return
                     }
                     
                     // 2. Firestore에 사용자 정보 저장
                     let userId = authResult?.user.uid
                     
                     let userInfo: [String: Any] = [
                        "email": self.user!.email,
                        "phoneNum": self.user!.phoneNum,
                        "nickname": nickname
                     ]
                     
                    self.db.collection("userInfo").document(userId!).setData(userInfo) { error in
                         if let error = error {
                             self.showAlert(message: "회원 가입 도중 오류가 발생했습니다. 다시 시도해주세요.")
                         } else {
                             self.performSegue(withIdentifier: "showNextScreen", sender: self)
                         }
                     }
                 }
            }
        }
    }
    func validation(_ string: String) -> Bool {
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}|:\"<>?`~[]\\;',./")
        return string.rangeOfCharacter(from: specialCharacterSet) != nil
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextScreen" {
            let destinationVC = segue.destination as! EndSignUpViewController
        }
    }
}
