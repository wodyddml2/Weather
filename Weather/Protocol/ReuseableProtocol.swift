import UIKit

protocol ReuseableProtocol {
    static var reuseableIdentifier: String { get }
}

extension UIViewController: ReuseableProtocol {
    static var reuseableIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: ReuseableProtocol {
    static var reuseableIdentifier: String {
        String(describing: self)
    }
}
