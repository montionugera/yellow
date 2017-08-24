// Pasit Nusso

import Foundation
import FirebaseAuth

class UserObject : NSObject {
    
    var uid: String?
    var email: String?
    
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    
    convenience init(authData: User) {
        self.init()
        uid = authData.uid
        email = authData.email!
    }
    
    
    static let shared = UserObject()
    
}
