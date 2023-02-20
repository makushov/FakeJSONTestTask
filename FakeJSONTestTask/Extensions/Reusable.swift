//
//  Reusable.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import UIKit

protocol Reusable {

    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}

extension UITableView {
    
    final func registerReusableCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(T.reuseIdentifier) "
                + "matching type \(cellType.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the cell beforehand"
            )
        }
        
        return cell
    }
}
