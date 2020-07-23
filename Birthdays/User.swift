import Foundation

class User: Codable{
    
    var userEmail: String = ""
    var contacts: [String] = [String]()
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
    init() {
    
    }
}
