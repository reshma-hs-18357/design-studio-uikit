//
//  TemplateViewController.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

class TemplatesExpandableViewController: UIViewController {

    private var tableView = UITableView(frame: .zero, style: .grouped)

    private var expandedTemplates: Set<Templates> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "TEMPLATES"
        view.backgroundColor = .systemBackground
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PageCell")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TemplatesExpandableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Templates.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let template = Templates.allCases[section]

        // If expanded, return pages count. Else, 0
        return expandedTemplates.contains(template) ? template.pageTypes.count : 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let template = Templates.allCases[indexPath.section]
        let pageType = template.pageTypes[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath)
        cell.textLabel?.text = pageType.pageName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension TemplatesExpandableViewController: UITableViewDelegate {

    // Handle tap on header → expand/collapse
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let template = Templates.allCases[indexPath.section]
        let pageType = template.pageTypes[indexPath.row]

        let vc = PageContentViewController(jsonSource: pageType.jsonSource)
        navigationController?.pushViewController(vc, animated: true)
    }

    // Custom Header View
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let template = Templates.allCases[section]

        let button = UIButton(type: .system)
        button.tag = section
        button.contentHorizontalAlignment = .left
//        button.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)

        let title = "\(template.rawValue)    (\(template.pageTypes.count) pages)"
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)

        return button
    }

    @objc private func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        let template = Templates.allCases[section]

        if expandedTemplates.contains(template) {
            expandedTemplates.remove(template)
        } else {
            expandedTemplates.insert(template)
        }

        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
