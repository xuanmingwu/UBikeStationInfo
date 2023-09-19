//
//  HomePageVC.swift
//  UbikeStationInfo
//
//  Created by 吳玹銘 on 2023/9/19.
//

import UIKit

class MenuPageVC: UIViewController {

    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()
        setupDismissBtn()
        loginBtn.layer.cornerRadius = 23

    }

    func setupLogo() {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Logo")
        headerView.addSubview(logoImageView)
        headerView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 32),
            logoImageView.heightAnchor.constraint(equalTo: headerView.heightAnchor),
            logoImageView.widthAnchor.constraint(equalTo: headerView.heightAnchor)
        ])
    }

    func setupDismissBtn() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "Color 1")
        headerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            button.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -40),
        ])

        button.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
    }

    @objc
    func btnPressed() {
        self.dismiss(animated: true)
    }

    @IBAction func stationBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
