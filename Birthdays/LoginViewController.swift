import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var login_TEXTFIELD_email: UITextField!
    @IBOutlet weak var login_TEXTFIELD_password: UITextField!
    
    var user : User!
        override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
    }
    
    // MARK: - SIGN IN
    @IBAction func login_BTN_log(_ sender: UIButton) {
        if let email = login_TEXTFIELD_email.text, let password = login_TEXTFIELD_password.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    var warningMessage: String!
                    warningMessage = err.localizedDescription
                    Helper.show(message: warningMessage)
                }else{
                    self.user = User(userEmail: email)
                    self.performSegue(withIdentifier: "sign_in", sender: self)
                }
            }
        }
    }

    // MARK: - Sign up
    @IBAction func login_BTN_reg(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sign_up", sender: self)
    }
    
    // MARK: - Prepare for viewController seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sign_in" {
            let destinationController = segue.destination as! ViewController
            destinationController.user = self.user
        }
    }
}
    // MARK: - Hide keyboard
extension LoginViewController {
    func hideKeyBoard() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyBoard))
        
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
}
