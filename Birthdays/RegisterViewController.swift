import UIKit
import Firebase
import FirebaseAuth
class RegisterViewController: UIViewController{
    

    @IBOutlet weak var register_TEXTFIELD_email: UITextField!
    @IBOutlet weak var register_TEXTFIELD_password: UITextField!
        
    var firebaseService : FirebaseService!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
        firebaseService = FirebaseService()
    }
    
    //MARK: - Register
    @IBAction func register_BTN_regiseration(_ sender: UIButton) {
        if let email = register_TEXTFIELD_email.text, let password = register_TEXTFIELD_password.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    var warningMessage: String!
                    warningMessage = err.localizedDescription
                    Helper.show(message: warningMessage)
                }else{
                    let user = User(userEmail: email)
                    self.firebaseService.setUser(user: user)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

    //MARK: - Hide keyboard
extension RegisterViewController {
    func hideKeyBoard() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }

}
