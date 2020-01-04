///
//  IosCore
//
//  Copyright © 2018 mkerekes. All rights reserved.
//
import UIKit

public enum SwipeAction {
    case delete
    case reply
    case report
    case edit
}

open class EditableTableViewController: TableViewController {
    open func didSwipe(with intention: SwipeAction, on path: IndexPath){ }
    open func swipeActions(at indexPath: IndexPath) -> [SwipeAction]? { return nil }
    
    open override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let actions:[SwipeAction] = swipeActions(at : indexPath) else { return nil }
        var uiaction:[UIContextualAction] = []
        for action in actions {
            switch action {
            case .delete:
                let deleteActionStyle = styleProvider?.list?.swipeActionCellDeleteStyle
                let delete = UIContextualAction(style: .normal, title: "") { [weak self] (action: UIContextualAction,
                    sourceView: UIView, actionPerformed: (Bool) -> Void) in
                    tableView.reloadData()
                    actionPerformed(true)
                    self?.didSwipe(with : .delete, on: indexPath)
                }
                delete.backgroundColor = deleteActionStyle?.color
                delete.image = deleteActionStyle?.image
                uiaction.append(delete)
            case .reply:
                let replyActionStyle = styleProvider?.list?.swipeActionCellReplyStyle
                let reply = UIContextualAction(style: .normal, title: "") { [weak self] (action: UIContextualAction,
                    sourceView: UIView, actionPerformed: (Bool) -> Void) in
                    tableView.reloadData()
                    self?.didSwipe(with: .reply, on: indexPath)
                    actionPerformed(true)
                    
                }
                reply.backgroundColor = replyActionStyle?.color
                reply.image = replyActionStyle?.image
                uiaction.append(reply)
            case.report:
                let reportActionStyle = styleProvider?.list?.swipeActionCellReportStyle
                let report = UIContextualAction(style: .normal, title: "") { [weak self] (action: UIContextualAction,
                    sourceView: UIView, actionPerformed: (Bool) -> Void) in
                    tableView.reloadData()
                    actionPerformed(true)
                    self?.didSwipe(with: .report, on: indexPath)
                }
                report.backgroundColor = reportActionStyle?.color
                report.image = reportActionStyle?.image
                uiaction.append(report)
            case.edit:
                let editActionStyle = styleProvider?.list?.swipeActionCellEditStyle
                let edit = UIContextualAction(style: .normal, title: "") { [weak self] (action: UIContextualAction,
                    sourceView: UIView, actionPerformed: (Bool) -> Void) in
                    tableView.reloadData()
                    actionPerformed(true)
                    self?.didSwipe(with: .edit, on: indexPath)
                }
                edit.backgroundColor = editActionStyle?.color
                edit.image = editActionStyle?.image
                uiaction.append(edit)
            }
        }
        return UISwipeActionsConfiguration(actions: uiaction)
    }
}
