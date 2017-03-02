//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class TableViewMock: UITableView {
    
    var didSetDelegation = false
    var didSetDataSource = false
    var didCallReload = false
    var didRegisterNib = false
    
    init() {
        super.init(frame: CGRect.zero, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override weak var delegate: UITableViewDelegate? {
        didSet {
            didSetDelegation = true
        }
    }
    
    override var dataSource: UITableViewDataSource? {
        didSet {
            didSetDataSource = true
        }
    }
    
    override func reloadData() {
        didCallReload = true
    }
    
    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        didRegisterNib = true
    }
}
