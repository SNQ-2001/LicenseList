//
//  LicenseListViewController.swift
//  
//
//  Created by ky0me22 on 2022/06/06.
//

import UIKit
import SwiftUI

public class LicenseListViewController: UIViewController {
    let fileURL: URL

    public var licenseListViewStyle: LicenseListViewStyle = .plain

    public init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }

    public convenience init?(bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: "license-list", withExtension: "plist") else {
            return nil
        }
        self.init(fileURL: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let licenseListView = LicenseListView(fileURL: fileURL, useUINavigationController: true) { [weak self] library in
            self?.navigateTo(library: library)
        }
        let vc = UIHostingController(rootView: licenseListView)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func navigateTo(library: Library) {
        let hostingController = UIHostingController(rootView: Group {
            if #available(iOS 15, *) {
                LicenseView(library: library)
                    .licenseListViewStyle(licenseListViewStyle)
            } else {
                LegacyLicenseView(library: library)
                    .licenseListViewStyle(licenseListViewStyle)
            }
        })
        hostingController.title = library.name
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}
