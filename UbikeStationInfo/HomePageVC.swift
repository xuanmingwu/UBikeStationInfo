//
//  ViewController.swift
//  UbikeStationInfo
//
//  Created by 吳玹銘 on 2023/9/19.
//

import UIKit

class HomePageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerViewForTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!

    var searchResultsTableView: UITableView!
    var ubikeStations: [UbikeStation] = []
    var filteredUbikeStations: [UbikeStation] = []
    let nib = UINib(nibName: "StationInfoTableViewCell", bundle: nil)


    override func viewDidLoad() {
        super.viewDidLoad()

        setupBottomBorder()
        setupMenuBtn()
        setupLogo()
        setupLabel()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.register(nib, forCellReuseIdentifier: "stationCell")
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        setupeSarchResultsTableView()

        UbikeStationManager.shared.fetchUbikeStations { (stations, error) in
            if let stations = stations {
                self.ubikeStations = stations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)


        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor(named: "Color 1")
        }
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
        searchBar.text = ""
        searchResultsTableView.isHidden = true
        filteredUbikeStations.removeAll()
        searchResultsTableView.reloadData()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let path = UIBezierPath(roundedRect: headerViewForTableView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = headerViewForTableView.bounds
        maskLayer.path = path.cgPath
        headerViewForTableView.layer.mask = maskLayer


    }

    func setupeSarchResultsTableView () {
        searchResultsTableView = UITableView()
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.rowHeight = 100
        searchResultsTableView.backgroundColor = .systemGray6
        searchResultsTableView.layer.cornerRadius = 10
        searchResultsTableView.separatorStyle = .none
        view.addSubview(searchResultsTableView)
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 2),
            searchResultsTableView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            searchResultsTableView.heightAnchor.constraint(equalToConstant: 400),
            searchResultsTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        searchResultsTableView.register(nib, forCellReuseIdentifier: "stationCell")
        searchResultsTableView.isHidden = true
    }

    // Setting label.text.
    func setupLabel() {
        if let textString = headerLabel.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.kern, value: 4, range: NSRange(location: 0, length: attributedString.length - 1))
            headerLabel.attributedText = attributedString
        }
    }


    // Setting border for headerView.
    func setupBottomBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor.quaternaryLabel.cgColor
        border.frame = CGRect(x: 0, y: headerView.frame.height - 1, width: headerView.frame.width, height: 1)
        headerView.layer.addSublayer(border)
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

    func setupMenuBtn () {
        let menuBtn = UIButton()
        let smallImage = UIImage(named: "MenuIcon")!
        let size = CGSize(width: 20, height: 15)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        smallImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuBtn.setImage(resizedImage, for: .normal)
        headerView.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            menuBtn.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -40),
        ])

        menuBtn.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
    }

    @objc
    func menuBtnPressed() {
        guard  let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuVC") as? MenuPageVC else {
            return
        }
            self.present(menuVC, animated: true)
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return ubikeStations.count
        } else if tableView == self.searchResultsTableView {
            return filteredUbikeStations.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as? StationInfoTableViewCell else {
            return UITableViewCell()
        }

        let station: UbikeStation
            if tableView == self.tableView {
                station = ubikeStations[indexPath.row]
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = UIColor.white
                } else {
                    cell.backgroundColor = UIColor.quaternarySystemFill
                }
            } else {
                station = filteredUbikeStations[indexPath.row]
                cell.backgroundColor = .clear

            }

        cell.districtLabel.text = station.sarea
        cell.stationNameLabel.text = station.sna

        return cell
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}


extension HomePageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUbikeStations = ubikeStations.filter { station in
            return station.sna.contains(searchText)
        }
        if filteredUbikeStations.isEmpty {
            searchResultsTableView.isHidden = true
        } else {
            searchResultsTableView.isHidden = false
        }
        searchResultsTableView.reloadData()
    }

}




