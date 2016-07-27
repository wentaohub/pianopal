//
//  IdentifyViewController.swift
//  pianopal
//
//  Created by Joshua Escribano on 7/23/16.
//  Copyright © 2016 Joshua Escribano. All rights reserved.
//

import UIKit

class IdentifyViewController: UIViewController, PianoNavigationProtocol {
    let pianoView = PianoView(frame: Dimensions.pianoRect)
    var pianoNavigationViewController: PianoNavigationViewController?
    var menuBarButton: UIBarButtonItem?
    var changeModeBarButton: UIBarButtonItem?
    var notesToIdentify = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationItem()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pianoView)
    }
    
    func setUpIdentifyMode() {
        for noteButton in pianoView.noteButtons {
            noteButton.addTarget(self, action: #selector(noteSelectedForIdentification), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func noteSelectedForIdentification(sender: NoteButton) {
        if sender.backgroundColor == Colors.identificationColor {
            sender.backgroundColor = sender.determineNoteColor(sender.note!)
            notesToIdentify.removeAtIndex(notesToIdentify.indexOf(sender.note!)!)
        } else {
            sender.backgroundColor = Colors.identificationColor
            notesToIdentify.append(sender.note!)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let identifiedChord = ChordIdentifier.chordForNotes(self.notesToIdentify)
                var chordDescription: String?
                if identifiedChord == nil {
                    chordDescription = "N/A"
                } else {
                    chordDescription = identifiedChord?.simpleDescription()
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.pianoNavigationViewController?.customNavigationItem.title = chordDescription
                })
            })
        }
    }
    
    func updateNavigationItem() {
        pianoNavigationViewController = (navigationController as! PianoNavigationViewController)
        pianoNavigationViewController?.customNavigationItem.titleView = nil
        changeModeBarButton = UIBarButtonItem(customView: pianoNavigationViewController!.changeModeButton)
        pianoNavigationViewController?.customNavigationItem.leftBarButtonItem = nil
        pianoNavigationViewController?.customNavigationItem.rightBarButtonItem = changeModeBarButton
        pianoNavigationViewController!.customNavigationItem.title = "Identify Chords"
        setUpIdentifyMode()
    }

}