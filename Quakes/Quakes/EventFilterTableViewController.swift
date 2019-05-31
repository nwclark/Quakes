//
//  EventFilterTableViewController.swift
//  Quakes
//
//  Created by Nathan Clark on 5/29/19.
//  Copyright © 2019 Nathan Clark. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import UIKit

/// Allows user to change event filters and control which events are shown on the map.
class EventFilterTableViewController: UITableViewController {

    fileprivate lazy var eventTableViewModelController = EventFilterTableViewModelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        self.initializeNavBar()
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return EventFilterTableViewController.Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventFilterTableViewController.Section.allCases[section].rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = EventFilterTableViewController.Section.allCases[indexPath.section].cellType
        let identifier = cellType.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EventFilterTableViewCell
        cell.connect(with: self.eventTableViewModelController, for: indexPath)
        // Configure the cell...
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return EventFilterTableViewController.Section.allCases[indexPath.section].cellType.cellHeight
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return EventFilterTableViewController.Section.allCases[section].cellType.sectionTitle
    }

    /// Register associated table view cell types with this view controller.
    fileprivate func registerNibs() {
        EventFilterTableViewController.Section.allCases.forEach {
            section in
            let identifier = section.cellType.identifier
            let nib = UINib(nibName: identifier, bundle: .main)
            self.tableView.register(nib, forCellReuseIdentifier: identifier)
        }
    }

    fileprivate func initializeNavBar() {
        let applyButton = UIBarButtonItem(title: "Apply", style: .plain, target: self,
                                          action: #selector(EventFilterTableViewController.saveAndExit))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(EventFilterTableViewController.cancelChangesAndExit))
        self.navigationItem.leftBarButtonItem = applyButton
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationItem.title = "Filters"
    }

    @objc fileprivate func saveAndExit() {
        self.eventTableViewModelController.saveChanges()
        self.popToRoot()
    }

    @objc fileprivate func cancelChangesAndExit() {
        self.popToRoot()
    }

    fileprivate func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension  EventFilterTableViewController {
    /// Maps the table view section to the corresponding event filter type.
    enum Section : CaseIterable {
        case magnitude
        case eventType

        var rows: Int {
            switch self {
            case .magnitude:
                return 1
            case .eventType:
                return EventType.allCases.count
            }
        }

        /// Maps table view sections to a cell type, allowing the view controller
        /// to access `EventFilterTableViewCell` members.
        var cellType: EventFilterTableViewCell.Type {
            switch self {
            case .magnitude:
                return EventFilterMagnitudeTableViewCell.self

            case .eventType:
                return EventFilterTypeTableViewCell.self
            }
        }
    }
}


/// Adopted by `UITableViewCells` so they can be displayed
/// by the `EventFilterTableViewController`.
protocol EventFilterTableViewCell: UITableViewCell {
    static var sectionTitle: String { get }
    static var cellHeight: CGFloat { get }
    static var identifier: String { get }

    func connect(with eventTableViewModelController: EventFilterTableViewModelController, for indexPath: IndexPath)
}
