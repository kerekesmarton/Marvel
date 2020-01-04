///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Presentation

class SettingsViewController: TableViewController, SettingsPresentationOutput {
    
    var presenter: SettingsPresenting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
    }
    
    override func applyStyle() {
        super.applyStyle()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings", for: indexPath)
        if let cell = cell as? SettingsPresentable{
            presenter.setup(cell: cell, for: indexPath)
        }        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        if let cell = cell as? SettingsPresentable{
            presenter.didTap(cell: cell, at: indexPath)
        }
    }
}

class SettingsCell: UITableViewCell, Styleable, SettingsPresentable  {
    func setup(title: String) {
        self.textLabel?.text = title
    }
    
    func applyStyle() {
        
    }
}
