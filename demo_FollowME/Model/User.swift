import Foundation

class User: NSObject, Codable, NSCoding {
    var id : String = ""
    var pw : String = ""
    var languages: [String] = [String]()
    var deviceToken = ""
    var profileImage = ""
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("followme_user")
    

    init(id: String, pw: String){
        self.id = id
        self.pw = pw
    }
    
    
    
    func setID(id: String){
        self.id = id
    }
    func setPW(pw: String){
        self.pw = pw
    }
    
    //자동 로그인 용
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "userID")
        aCoder.encode(pw, forKey: "userPW")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "userID") as? String
        let pw = aDecoder.decodeObject(forKey: "userPW") as? String
        self.init(id: id!, pw: pw!)
    }
}
