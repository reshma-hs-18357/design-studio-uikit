//
//  PageContentViewController.swift
//  DesignStudioUIKit
//
//  Created by Reshma S on 13/11/25.
//

import UIKit

class PageContentViewController: UIViewController {
    
    let jsonSource: String

    // MARK: - State
    private var elementsMap: [String: ElementViewModel] = [:]
    private var rootElement: ElementViewModel?
    private var isLoading = true {
        didSet { updateUI() }
    }
    private var errorMessage: String? {
        didSet { updateUI() }
    }

    // MARK: - UI Elements
    private let loadingView = LoadingPageView()
    private let errorView = ErrorPageView()
    private let contentContainer = UIView()

    // MARK: - Init
    init(jsonSource: String) {
        self.jsonSource = jsonSource
        super.init(nibName: nil, bundle: nil)
        self.title = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupNavigation()
        setupUI()
        loadPageContent()
    }

    // MARK: - Navigation
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(dismissSelf)
        )
    }

    @objc private func dismissSelf() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(loadingView)
        view.addSubview(errorView)
        view.addSubview(contentContainer)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - UI State
    private func updateUI() {
        loadingView.isHidden = !isLoading
        errorView.isHidden = (errorMessage == nil || isLoading)
        contentContainer.isHidden = (isLoading || errorMessage != nil)

        if let errorMessage = errorMessage {
            errorView.configure(message: errorMessage, retry: { [weak self] in
                self?.retryLoading()
            })
        }

        if !isLoading && errorMessage == nil, let root = rootElement {
            renderContent(root: root)
        }
    }

    private func renderContent(root: ElementViewModel) {

        contentContainer.subviews.forEach { $0.removeFromSuperview() }

        // Placeholder – replace with your real ElementRenderer UIView
        let renderer = ElementRendererView(element: root, elementsMap: elementsMap)

        contentContainer.addSubview(renderer)
        renderer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            renderer.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            renderer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor)
        ])
    }


    private func loadPageContent() {
        isLoading = true
        errorMessage = nil
        rootElement = nil
        elementsMap = [:]

        DispatchQueue.global().async {
            do {
                let jsonString = try self.getJsonString()
                let decoded = try self.decodeJsonString(jsonString)
                let viewModelMap = try self.createViewModelMap(from: decoded)
                let root = try self.findRootElement(from: decoded, in: viewModelMap)

                DispatchQueue.main.async {
                    self.elementsMap = viewModelMap
                    self.rootElement = root
                    self.isLoading = false
                }

            } catch let jsonError as JsonParserError {
                DispatchQueue.main.async {
                    self.errorMessage = jsonError.localizedDescription
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Unexpected Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    private func retryLoading() {
        loadPageContent()
    }
}
