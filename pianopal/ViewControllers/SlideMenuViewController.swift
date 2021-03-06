//
//  SlideMenuViewController.swift
//  pianopal
//
//  Created by Joshua Escribano on 7/31/16.
//  Copyright © 2016 Joshua Escribano. All rights reserved.
//

import UIKit

enum NavigationPage : Int {
    case ChordProgression, ScaleProgression, Identify, Chords, Scales, Settings, Sessions
    
    func simpleDescription() -> String {
        if (self == NavigationPage.ChordProgression) {
            return "Chord Progression"
        } else if (self == NavigationPage.ScaleProgression) {
            return "Scale Progression"
        } else {
            return "\(self)"
        }
    }
}

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let offset: CGFloat = 200
    let navigationItems = [NavigationPage.ChordProgression, NavigationPage.ScaleProgression, NavigationPage.Identify, NavigationPage.Chords, NavigationPage.Scales, NavigationPage.Sessions, NavigationPage.Settings]
    var pianoNavigationController: PianoNavigationViewController?
    var tableView: UITableView?
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: UIScreen.main.bounds)
        tableView!.rowHeight = 60
        tableView!.tableFooterView = UIView(frame: CGRect.zero)
        tableView!.backgroundColor = Colors.navigationBackground
        tableView!.separatorColor = Colors.navigationSeparator
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.cellLayoutMarginsFollowReadableWidth = false
        
        pianoNavigationController!.view.layer.shadowOpacity = 0.8
        view.addSubview(tableView!)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell =  SlideMenuTableViewCell(style: .default, reuseIdentifier: "navigationPage")
        tableViewCell.textLabel!.text = navigationItems[(indexPath as NSIndexPath).row].simpleDescription()
        tableViewCell.textLabel!.font = Fonts.navigationItem
        tableViewCell.backgroundColor = Colors.navigationBackground
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navigationItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pianoNavigationController!.stopPlaying()
        let pianoViewController = pianoNavigationController!.pianoViewController
        switch navigationItems[(indexPath as NSIndexPath).row] {
            case .ChordProgression:
                pianoNavigationController!.goToChordTableView()
            case .ScaleProgression:
                pianoNavigationController!.goToScaleTableView()
            case .Chords:
                pianoViewController.pianoViewMode = PianoViewMode.chord
                pianoNavigationController!.goToPianoView()
            case .Scales:
                pianoViewController.pianoViewMode = PianoViewMode.scale
                pianoNavigationController!.goToPianoView()
            case .Identify:
                pianoViewController.pianoViewMode = PianoViewMode.identify
                pianoNavigationController!.goToPianoView()
            case .Settings:
                pianoNavigationController!.goToSettingsView()
            case .Sessions:
                pianoNavigationController!.goToSessionsView()
        }
        pianoNavigationController!.toggleSlideMenuPanel()
    }
    
    func togglePanel() {
        if (isExpanded) {
            collapsePanel()
            isExpanded = false
        } else {
            expandPanel()
            isExpanded = true
        }
    }
    
    func expandPanel(_ offset: CGFloat = SlideMenuViewController.offset) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
                self.pianoNavigationController!.view.frame.origin.x = SlideMenuViewController.offset
            }, completion: nil)
        
        if let sVC = pianoNavigationController?.topViewController as? SessionsViewController {
            sVC.tableView?.isEditing = false
            sVC.nameTextField?.endEditing(true)
        }
    }
    
    func collapsePanel() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.pianoNavigationController!.view.frame.origin.x = 0
            }, completion: { (Bool) in
                self.view.removeFromSuperview()
        })
    }
}
